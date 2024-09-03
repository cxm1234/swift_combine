
import Foundation
import Combine

let computationPubliser = Publishers.ExpensiveComputation(duration: 3)

let queue = DispatchQueue(label: "serial queue")

let currentThread = Thread.current.number

print("Start computation publisher on thread \(String(describing: currentThread))")

let subscription = computationPubliser
    .subscribe(on: queue)
    .receive(on: DispatchQueue.main)
    .sink { value in
    let thread = Thread.current.number
    print("Received computation result on thread \(String(describing: thread)): '\(value)'")
}


//: [Next](@next)
