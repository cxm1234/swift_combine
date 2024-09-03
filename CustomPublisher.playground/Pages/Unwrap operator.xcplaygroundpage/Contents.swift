//: [Previous](@previous)

import Combine

extension Publisher {
    func unwarp<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        compactMap { $0 }
    }
}

//: [Next](@next)
