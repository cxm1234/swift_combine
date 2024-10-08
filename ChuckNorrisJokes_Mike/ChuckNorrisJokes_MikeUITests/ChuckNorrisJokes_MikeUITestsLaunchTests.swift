//
//  ChuckNorrisJokes_MikeUITestsLaunchTests.swift
//  ChuckNorrisJokes_MikeUITests
//
//  Created by Mike_Tree on 10/8/24.
//

import XCTest

final class ChuckNorrisJokes_MikeUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
