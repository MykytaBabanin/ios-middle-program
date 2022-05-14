//
//  NotesUITestsLaunchTests.swift
//  NotesUITests
//
//  Created by Mykyta Babanin on 25.04.2022.
//

import XCTest

class NotesUITestsLaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testRelaunch() throws {
        let app = XCUIApplication()
        app.terminate()
        app.resetAuthorizationStatus(for: .keyboardNetwork)
    }
}
