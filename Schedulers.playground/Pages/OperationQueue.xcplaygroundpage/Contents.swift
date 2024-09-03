//: [Previous](@previous)

import Combine
import Foundation

let queue = OperationQueue()
queue.maxConcurrentOperationCount = 1

let subscription = (1...10).publisher
    .receive(on: queue)
    .sink { value in
        print("Received \(value) on thread \(Thread.current.number)")
    }

//: [Next](@next)
