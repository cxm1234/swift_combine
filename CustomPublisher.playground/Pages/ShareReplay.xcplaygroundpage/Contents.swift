//: [Previous](@previous)

import Foundation
import Combine

fileprivate final class ShareReplaySubscription<Output, Failure: Error>: Subscription {
    
    let capacity: Int
    var subscriber: AnySubscriber<Output, Failure>? = nil
    var demand: Subscribers.Demand = .none
    var buffer: [Output]
    var completion: Subscribers.Completion<Failure>? = nil
    
    init<S>(subscriber: S, replay: [Output], capacity: Int, completion: Subscribers.Completion<Failure>?) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        self.subscriber = AnySubscriber(subscriber)
        self.buffer = replay
        self.capacity = capacity
        self.completion = completion
    }
    
    func request(_ demand: Subscribers.Demand) {
        if demand != .none {
            self.demand += demand
        }
        emitAsNeeded()
    }
    
    func cancel() {
        complete(with: .finished)
    }
    
    func receive(_ input: Output) {
        guard subscriber != nil else { return }
        buffer.append(input)
        if buffer.count > capacity {
            buffer.removeFirst()
        }
        emitAsNeeded()
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        guard let subscriber = subscriber else {
            return
        }
        self.subscriber = nil
        self.buffer.removeAll()
        subscriber.receive(completion: completion)
    }
    
    private func complete(with completion: Subscribers.Completion<Failure>) {
        guard let subscriber = subscriber else { return }
        self.subscriber = nil
        self.completion = nil
        self.buffer.removeAll()
        subscriber.receive(completion: completion)
    }
    
    private func emitAsNeeded() {
        guard let subscriber = subscriber else { return }
        while self.demand > .none && !buffer.isEmpty {
            self.demand -= .max(1)
            let nextDemand = subscriber.receive(buffer.removeFirst())
            if nextDemand != .none {
                self.demand += nextDemand
            }
        }
        if let completion = completion {
            complete(with: completion)
        }
    }
    
}

extension Publishers {
    final class ShareReplay<Upstream: Publisher>: Publisher {
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure
        
        private let lock = NSRecursiveLock()
        private let upstream: Upstream
        private let capacity: Int
        private var replay = [Output]()
        private var subscriptions = [ShareReplaySubscription<Output, Failure>]()
        private var completion: Subscribers.Completion<Failure>? = nil
        
        init(upstream: Upstream, capacity: Int) {
            self.upstream = upstream
            self.capacity = capacity
        }
        
        func receive<S: Subscriber>(subscriber: S)
        where Failure == S.Failure,
              Output == S.Input {
                  lock.lock()
                  defer { lock.unlock() }
                  
                  let subscription = ShareReplaySubscription(
                    subscriber: subscriber,
                    replay: replay,
                    capacity: capacity,
                    completion: completion
                  )
                  
                  subscriptions.append(subscription)
                  subscriber.receive(subscription: subscription)

                  guard subscriptions.count == 1 else {
                      return
                  }
                  
                  let sink = AnySubscriber { subscription in
                      subscription.request(.unlimited)
                  } receiveValue: { [weak self] (value: Output) -> Subscribers.Demand in
                      self?.relay(value)
                      return .none
                  } receiveCompletion: { [weak self] in
                      self?.complete($0)
                  }
                  
                  upstream.subscribe(sink)
              }
        
        private func relay(_ value: Output) {
            lock.lock()
            defer {
                lock.unlock()
            }
            guard completion == nil else {
                return
            }
            replay.append(value)
            if replay.count > capacity {
                replay.removeFirst()
            }
            subscriptions.forEach {
                $0.receive(value)
            }
        }
        
        private func complete(_ completion: Subscribers.Completion<Failure>) {
            lock.lock()
            defer { lock.unlock() }
            self.completion = completion
            subscriptions.forEach {
                $0.receive(completion: completion)
            }
        }
    }
}

extension Publisher {
    func shareReplay(capacity: Int = .max) -> Publishers.ShareReplay<Self> {
        return Publishers.ShareReplay(upstream: self, capacity: capacity)
    }
}

var logger = TimeLogger(sinceOrigin: true)
let subject = PassthroughSubject<Int, Never>()

let publisher = subject
    .print("shareReplay")
    .shareReplay(capacity: 2)

subject.send(0)

let subscription1 = publisher.sink {
    print("subscription1 completed: \($0)", to: &logger)
} receiveValue: {
    print("subscription1 received \($0)", to: &logger)
}

subject.send(1)
subject.send(2)
subject.send(3)

let subscription2 = publisher.sink {
    print("subscription2 completed: \($0)", to: &logger)
} receiveValue: {
    print("subscription2 received \($0)", to: &logger)
}

subject.send(4)
subject.send(5)
subject.send(completion: .finished)

var subscription3: Cancellable? = nil

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    print("Subscribing to shareReplay after upstream completed")
    subscription3 = publisher.sink(receiveCompletion: {
        print("subscription3 completed: \($0)", to: &logger)
    }, receiveValue: {
        print("subscription3 received \($0)", to: &logger)
    })
}

//: [Next](@next)
