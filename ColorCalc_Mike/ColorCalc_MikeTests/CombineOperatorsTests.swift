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
        
//        let publisher
    }
}
