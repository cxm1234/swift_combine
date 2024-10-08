//
//  CombineOperatorsTests.swift
//  ColorCalc_MikeTests
//
//  Created by Mike_Tree on 9/29/24.
//

import XCTest
import Combine

class CombineOperatorsTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
    
    func test_collect() {
        let values = [0, 1, 2]
        let publisher = values.publisher
        publisher
            .collect()
            .sink {
                XCTAssert(
                    $0 == values,
                    "Result was expected to be \(values) but was \($0)"
                )
            }
            .store(in: &subscriptions)
    }
    
    func test_flatMapWithMax2Publishers() {
        let intSubject1 = PassthroughSubject<Int, Never>()
        let intSubject2 = PassthroughSubject<Int, Never>()
        let intSubject3 = PassthroughSubject<Int, Never>()
        
        let publisher = CurrentValueSubject<PassthroughSubject<Int, Never>, Never>(intSubject1)
        
        let expected = [1, 2, 4]
        var results = [Int]()
        
        publisher
            .flatMap(maxPublishers: .max(2)) {
                $0
            }
            .sink {
                results.append($0)
            }
            .store(in: &subscriptions)
        
        intSubject1.send(1)
        publisher.send(intSubject2)
        intSubject1.send(2)
        
        publisher.send(intSubject3)
        intSubject3.send(3)
        intSubject2.send(4)
        
        publisher.send(completion: .finished)
        
        XCTAssert(results == expected, "Results expected to be \(expected) but were \(results)")
        
    }
    
    func test_timerPublish() {
        
        func normalized(_ ti: TimeInterval) -> TimeInterval {
            return Double(round(ti * 10) / 10)
        }
        
        let now = Date().timeIntervalSinceReferenceDate
        let expectation = self.expectation(description: #function)
        let expected = [0.5, 1, 1.5]
        var results = [TimeInterval]()
        
        let publisher = Timer
            .publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .prefix(3)
        
        publisher
            .sink(receiveCompletion: { _ in expectation.fulfill()}, receiveValue: {
                results.append(normalized($0.timeIntervalSinceReferenceDate - now))
            })
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssert(results == expected, "Results expected to be \(expected) but were \(results)")
        
    }
    
//    func test_shareReplay() {
//        let subject = PassthroughSubject<Int, Never>()
//        let publisher = subject.shareReplay(capacity: 2)
//        let expected = [0, 1, 2, 1, 2, 3, 3]
//        var results = [Int]()
//    }
}
