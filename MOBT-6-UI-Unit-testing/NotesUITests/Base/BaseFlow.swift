//
//  BaseFlow.swift
//  NotesUITests
//
//  Created by Mykyta Babanin on 25.04.2022.
//

import XCTest

class BaseFlow {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    lazy var notesScreen = NotesScreen(app: app)
}
