//
//  ColorCalc_MikeTests.swift
//  ColorCalc_MikeTests
//
//  Created by ming on 2024/9/19.
//

import XCTest
import Combine
import SwiftUI
@testable import ColorCalc_Mike

final class ColorCalc_MikeTests: XCTestCase {
    
    var viewModel: CalculatorViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        viewModel = CalculatorViewModel()
    }
    
    override func tearDown() {
        subscriptions = []
    }
    
    func test_correctNameReceived() {
        let expected = "rwGreen 66%"
        var result = ""
        
        viewModel.$name
            .sink(receiveValue: { result = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = "006636AA"
        
        XCTAssert(result == expected, "Name expected to be \(expected) but was \(result)")
    }
    
    func test_processBackspaceDeletesLastCharacter() {
        // Given
        // 1
        let expected = "#0080F"
        var result = ""
        
        // 2
        viewModel.$hexText
            .dropFirst()
            .sink(receiveValue: { result = $0 })
            .store(in: &subscriptions)
        
        // when
        // 3
        viewModel.process(CalculatorViewModel.Constant.backspace)
        
        // Then
        // 4
        XCTAssert(result == expected, "Hex was expected to be \(expected) but was \(result)")
    }
    
    func test_correctColorReceived() {
        let expected = Color(hex: ColorName.rwGreen.rawValue)!
        var result: Color = .clear
        
        viewModel.$color
            .sink(receiveValue: { result = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = ColorName.rwGreen.rawValue
        
        XCTAssert(result == expected, "Color expected to be \(expected) but was \(result)")
    }
    
    func test_processBackspaceReceivesCorrectColor() {
        let expected = Color.white
        var result = Color.clear
        
        viewModel.$color
            .sink(receiveValue: { result = $0 })
            .store(in: &subscriptions)
        
        viewModel.process(CalculatorViewModel.Constant.backspace)
        
        XCTAssert(result == expected, "Hex was expected to be \(expected) but was \(result)")
    }
    
    func test_whiteColorReceivedForBadData() {
        let expected = Color.white
        var result = Color.clear
        
        viewModel.$color
            .sink(receiveValue: { result = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = "abc"
        
        XCTAssert(result == expected, "Color expected to be \(expected) but was \(result)")
    }
    
    func test_processClearSetsHexToHashtag() {
        let expected = "#"
        var result = ""
        
        viewModel.$hexText
            .dropFirst()
            .sink(receiveValue: { result = $0 } )
            .store(in: &subscriptions)
        
        viewModel.process(CalculatorViewModel.Constant.clear)
        
        XCTAssertTrue(result == expected, "Hex was expected to be \(expected) but was \"\(result)\"")
    }
    
    func test_correctRGBOTextReceived() {
        let expected = "0, 102, 54, 170"
        var result = ""
        
        viewModel.$rgboText
            .sink(receiveValue: { result = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = "#006636AA"
        
        XCTAssert(result == expected, "RGBO text expected to be \(expected) but was \(result)")
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
