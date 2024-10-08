import Foundation
import Combine
var subscriptions = Set<AnyCancellable>()

//: ## Never
//example(of: "Never sink") {
//    Just("Hello")
//        .sink(receiveValue: { print($0) })
//        .store(in: &subscriptions)
//}

enum MyError: Error {
    case ohNo
}

//example(of: "setFailureType") {
//    Just("Hello")
//        .setFailureType(to: MyError.self)
//        .sink { completion in
//            switch completion {
//            case .failure(.ohNo):
//                print("Finished with oh No!")
//            case .finished:
//                print("Finished successfully!")
//            }
//        } receiveValue: { value in
//            print("Got value: \(value)")
//        }
//        .store(in: &subscriptions)
//
//}

//example(of: "assign(to:on:)") {
//    class Person {
//        let id = UUID()
//        var name = "Unknown"
//    }
//    
//    let person = Person()
//    print("1", person.name)
//    Just("Shai")
//        .handleEvents(
//            receiveCompletion: { _ in print("2", person.name) }
//        )
//        .assign(to: \.name, on: person)
//        .store(in: &subscriptions)
//}

//example(of: "assign(to:)") {
//    class MyViewModel: ObservableObject {
//        @Published var currentDate = Date()
//        
//        init() {
//            Timer.publish(every: 1, on: .main, in: .common)
//                .autoconnect()
//                .prefix(3)
//                .assign(to: &$currentDate)
//        }
//    }
//    
//    let vm = MyViewModel()
//    vm.$currentDate
//        .sink(receiveValue: { print($0) })
//        .store(in: &subscriptions)
//}

//example(of: "assertNoFailure") {
//    Just("Hello")
//        .setFailureType(to: MyError.self)
//        .assertNoFailure()
//        .sink(receiveValue: { print("Got value: \($0)")})
//        .store(in: &subscriptions)
//}
//: [Next](@next)
