//
//  NotesUITests.swift
//  NotesUITests
//
//  Created by Mykyta Babanin on 25.04.2022.
//

import XCTest

class NotesUITests: BaseUITest {

    override func setUp() {
        super.setUp()
        app.launch()
    }
        
    func testCreateFolder() throws {
        notesFlow.createFolder()
        notesFlow.inputText()
        notesFlow.clickSave()
        XCTAssertEqual(notesFlow.notesScreen.noteDescription, notesFlow.stringInput)
    }
    
    func testViewListFolders() throws {
        notesFlow.clickOnNote()
        XCTAssert(notesFlow.tableCellGreaterOrEqualNull())
    }
    
    func testFoldersListWithExistingFolders() throws {
        notesFlow.clickOnNote()
        notesFlow.createNewNote()
        notesFlow.inputTextInsideNote()
    }
    
    override func tearDown() {
        app.terminate()
    }
}
