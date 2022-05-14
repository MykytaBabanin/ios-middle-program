//
//  NotesFlow.swift
//  NotesUITests
//
//  Created by Mykyta Babanin on 25.04.2022.
//

import XCTest

class NotesFlow: BaseFlow {
    
    let stringInput = "folder"
    
    func createFolder() {
        XCTContext.runActivity(named: "Create Folder") { _ in
            notesScreen.createFolder.tap()
        }
    }
    
    func inputText() {
        XCTContext.runActivity(named: "Input Text") { _ in
            notesScreen.createFolderTextField.typeText(stringInput)
        }
    }
    
    func clickSave() {
        XCTContext.runActivity(named: "Click Save") { _ in
            notesScreen.saveButton.tap()
        }
    }
    
    func clickOnNote() {
        XCTContext.runActivity(named: "Click on Note") { _ in
            notesScreen.noteLabel(cellName: stringInput).tap()
        }
    }
    
    func createNewNote() {
        XCTContext.runActivity(named: "Create a new note") { _ in
            notesScreen.createNoteButton.tap()
        }
    }
    
    func inputTextInsideNote() {
        XCTContext.runActivity(named: "Input text inside the note") { _ in
            notesScreen.textViewNote.tap()
            notesScreen.textViewNote.typeText(stringInput)
            notesScreen.backNavigationBar.tap()
        }
    }
    
    func tableCellGreaterOrEqualNull() -> Bool {
        XCTContext.runActivity(named: "Check for greater or equal to null of table view cells") { _ in
            return app.tables.staticTexts.count > 0 ? true : false
        }
    }
}
