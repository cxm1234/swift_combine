//: [Previous](@previous)

import Foundation
import Combine

//let queue = OperationQueue()
//let subscription = queue.publisher(for: \.operationCount).sink {
//    print("Outstanding operations in queue: \($0)")
//}

//class TestObject: NSObject {
//    @objc dynamic var integerProperty: Int = 0
//    @objc dynamic var stringProperty: String = ""
//    @objc dynamic var arrayProperty: [Float] = []
//    
//}
//
//let obj = TestObject()
//
//let subscription = obj.publisher(for: \.integerProperty, options: [.prior])
//    .sink {
//        print("integerProperty changes to \($0)")
//    }
//
//obj.integerProperty = 100
//obj.integerProperty = 200
//
//let subscription2 = obj.publisher(for: \.stringProperty, options: [])
//    .sink {
//        print("stringProperty changes to \($0)")
//    }
//
//let subscription3 = obj.publisher(for: \.arrayProperty, options: [])
//    .sink {
//        print("arrayProperty changes to \($0)")
//    }
//
//obj.stringProperty = "Hello"
//obj.arrayProperty = [1.0]
//obj.stringProperty = "World"
//obj.arrayProperty = [1.0, 2.0]
//
//obj.integerProperty = 300

//
//class MonitorObject: ObservableObject {
//    
//    @Published var someProperty = false
//    @Published var someOtherProperty = ""
//    
//}
//
//let object = MonitorObject()
//let subscription = object.objectWillChange.sink {
//    print("object will change")
//}
//
//object.someProperty = true
//object.someOtherProperty = "Hello world"

//let shared = URLSession.shared
//    .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
//    .map(\.data)
//    .print("shared")
//    .share()
//
//print("subscribing first")
//
//let subscription1 = shared.sink(
//    receiveCompletion: { _ in },
//    receiveValue: { print("subscription1 received: '\($0)' ")}
//)
//
//var subscription2: AnyCancellable? = nil
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//    print("subscribing second")
//    subscription2 = shared.sink(
//        receiveCompletion: { print("subscription2 completion \($0)")},
//        receiveValue: { print("subscription2 received: '\($0)'")}
//    )
//}

//let subject = PassthroughSubject<Data, URLError>()
//
//let multicasted = URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
//    .map(\.data)
//    .print("multicast")
//    .multicast(subject: subject)
//
//let subscription1 = multicasted
//    .sink(
//        receiveCompletion: { _ in },
//        receiveValue: { print("subscription1 received: '\($0)'")}
//    )
//
//let subscription2 = multicasted
//    .sink(
//        receiveCompletion: { _ in },
//        receiveValue: { print("subscription2 received: '\($0)'")}
//    )
//
//let cancellable = multicasted.connect()

func performSomeWork() throws -> Int {
    print("Performing some work and returnning a result")
    return 5
}

let future = Future<Int, Error>{ fulfill in
    do {
        let result = try performSomeWork()
        fulfill(.success(result))
    } catch {
        fulfill(.failure(error))
    }
}

print("Subscribing to future...")

let subscription1 = future
    .sink(
        receiveCompletion: { _ in print("subscription1 completed")},
        receiveValue: { print("subscription1 received: '\($0)'")}
    )

let subscription2 = future
    .sink(
        receiveCompletion: { _ in print("subscription2 completed")},
        receiveValue: { print("subscription2 received: '\($0)'")}
    )
//: [Next](@next)
