//
//  BaseUITest.swift
//  NotesUITests
//
//  Created by Mykyta Babanin on 25.04.2022.
//

import XCTest

class BaseUITest: XCTestCase {
    lazy var app = XCUIApplication()
    
    lazy var notesFlow = NotesFlow(app: app)
}
