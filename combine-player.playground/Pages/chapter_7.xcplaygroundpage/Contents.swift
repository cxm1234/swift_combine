//: [Previous](@previous)

import Foundation
import Combine

guard let url = URL(string: "https://www.raywenderlich.com") else {
    fatalError("Error URL")
}

let publisher = URLSession.shared
    .dataTaskPublisher(for: url)
    .map(\.data)
    .multicast {
        PassthroughSubject<Data, URLError>()
    }

let subscription1 = publisher
    .sink(receiveCompletion: { completion in
        if case .failure(let failure) = completion {
            print("Sink1 Retrieving data failed with error \(failure)")
        }
    }, receiveValue: { object in
        print("Sink1 Retrieved object \(object)")
    })

let subscription2 = publisher
    .sink(receiveCompletion: { completion in
        if case .failure(let failure) = completion {
            print("Sink2 Retrieving data failed with error \(failure)")
        }
    }, receiveValue: { object in
        print("Sink2 Retrieved object \(object)")
    })

let subscription = publisher.connect()
//: [Next](@next)
