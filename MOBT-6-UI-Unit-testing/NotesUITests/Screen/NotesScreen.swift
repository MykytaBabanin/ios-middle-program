//
//  NotesScreen.swift
//  NotesUITests
//
//  Created by Mykyta Babanin on 25.04.2022.
//

import XCTest

class NotesScreen: BaseScreen {
    
    init(app: XCUIApplication) {
        super.init(app: app, loadableElementPredicate: NSPredicate(format: "identifier = ''"))
    }
    
    var createFolder: XCUIElement {
        return app.buttons["addFolderButton"]
    }
    
    var createFolderTextField: XCUIElement {
        return app.textFields["textField"]
    }
    
    var noteIdentifier: XCUIElement {
        return app.otherElements["folderNameLabel"]
    }
    
    var noteDescription: String {
        return app.staticTexts["folderNameLabel"].label
    }
    
    var waitForExistenceNoteLabel: Bool {
        return noteIdentifier.waitForExistence(timeout: 2)
    }
    
    var saveButton: XCUIElement {
        return app.buttons["saveButton"]
    }
    
    var createNoteButton: XCUIElement {
        return app.buttons["addNoteButton"]
    }
    
    var textViewNote: XCUIElement {
        return app.textViews["noteTextView"]
    }
    
    var backNavigationBar: XCUIElement {
        return app.navigationBars.buttons.firstMatch
    }
    
    func noteLabel(cellName: String) -> XCUIElement {
        return app.cells[cellName]
    }
}
