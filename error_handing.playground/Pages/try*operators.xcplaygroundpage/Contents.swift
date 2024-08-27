//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

//example(of: "tryMap") {
//    enum NameError: Error {
//        case tooShort(String)
//        case unknown
//    }
//    let names = ["Marin", "Shai", "Florent"].publisher
//    names
//        .tryMap { value in
//            let length = value.count
//            guard length >= 5 else {
//                throw NameError.tooShort(value)
//            }
//            return value.count
//        }
//        .sink(receiveCompletion: { print("Completed with \($0)")}, receiveValue: { print("Got value: \($0)")}
//        )
//}
//
//example(of: "map vs tryMap") {
//    enum NameError: Error {
//        case tooShort(String)
//        case unknown
//    }
//    
//    Just("Hello")
//        .setFailureType(to: NameError.self)
//        .tryMap { throw NameError.tooShort($0) }
//        .mapError { $0 as? NameError ?? .unknown }
//        .sink(
//            receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    print("Done!")
//                case .failure(.tooShort(let name)):
//                    print("\(name) is too short!")
//                case .failure(.unknown):
//                    print("An unknown name error occurred")
//                }
//            }, receiveValue: { print("Got value \($0)")}
//        )
//        .store(in: &subscriptions)
//}



//: [Next](@next)
