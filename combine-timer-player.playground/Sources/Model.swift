import Foundation
import Combine

public enum Event: Equatable {
    case value
    case completion
    case failure
}

public struct CombineEvent {
    public let index: Int
    public let time: TimeInterval
    public let event: Event
    
    public var groupTime: Int { Int(floor(time * 10.0)) }
    public var isValue: Bool { self.event == .value }
    public var isCompletion: Bool { self.event == .completion }
    
    public init(index: Int, time: TimeInterval, event: Event) {
        self.index = index
        self.time = time
        self.event = event
    }
}

struct CombineEvents: Identifiable {
    let events: [CombineEvent]
    var time: TimeInterval { events[0].time }
    var id: Int { (events[0].groupTime << 16 ) | events.count }
}

class EventsHolder {
    var events = [CombineEvent]()
    var startDate = Date()
    var nextIndex = 1
    
    init() {}
    
    init(events: [CombineEvent]) {
        self.events = events
    }
    
    func capture(_ event: Event) {
        let time = Date().timeIntervalSince(startDate)
        if case .completion = event, let lastEvent = events.last, (time - lastEvent.time) < 1.0 {
            events.append(CombineEvent(index: nextIndex, time: lastEvent.time + 1.0, event: event))
        } else {
            events.append(CombineEvent(index: nextIndex, time: time, event: event))
        }
        nextIndex += 1
        
        while let e = events.first {
            guard (time - e.time) > 15.0 else { break }
            events.removeFirst()
        }
    }
}

public final class DisplayTimer: ObservableObject {
    @Published var current: CGFloat = 0
    var cancellable: Cancellable? = nil
    
    public init() {
        DispatchQueue.main.async {
            self.cancellable = self.start()
        }
    }
    
    public func start() -> Cancellable {
        return Timer
            .publish(every: 1.0 / 30, on: .main, in: .common)
            .autoconnect()
            .scan(CGFloat(0)) { (counter, _) in counter + 1 }
            .sink { counter in
                self.current = counter
            }
    }
    
    public func stop(after: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.cancellable?.cancel()
        }
    }
}
