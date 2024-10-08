//
//  JokesViewModelTests.swift
//  ChuckNorrisJokes_MikeTests
//
//  Created by Mike_Tree on 10/8/24.
//

import XCTest
import Combine
import SwiftUI
@testable import ChuckNorrisJokesModel

final class JokesViewModelTests: XCTestCase {
    private lazy var testJoke = self.testJoke(forResource: "TestJoke")
    private lazy var testTranslatedJokeValue = self.testJoke(forResource: "TestTranslatedJoke").value.value
    private lazy var error = URLError(.badServerResponse)
    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }
    
    private func testJoke(forResource resource: String) -> (data: Data, value: Joke) {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let joke = try? JSONDecoder().decode(Joke.self, from: data) else {
            fatalError("Failed to load \(resource)")
        }
        return (data, joke)
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
