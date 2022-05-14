//
//  BaseScreen.swift
//  NotesUITests
//
//  Created by Mykyta Babanin on 25.04.2022.
//

import XCTest

class BaseScreen {
    let app: XCUIApplication
    let loadableElementPredicate: NSPredicate
    private lazy var loadableElementQuery = app.descendants(matching: XCUIElement.ElementType.any).matching(loadableElementPredicate)
    
    init(app: XCUIApplication, loadableElementPredicate: NSPredicate) {
        self.app = app
        self.loadableElementPredicate = loadableElementPredicate
    }
}
