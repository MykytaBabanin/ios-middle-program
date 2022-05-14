//
//  NoteDetailsViewModel.swift
//  Notes
//
//

import Foundation
import CoreData

class NoteDetailsViewModel {
    private let folderId: NSManagedObjectID
    private lazy var creationDate: Date = { note?.creationDate ?? Date() }()
    
    var note: Note?
    var creationDateTitle: String { creationDate.shortDate() }
    var body: String? { note?.body }
    
    init(folderId: NSManagedObjectID) {
        self.folderId = folderId
    }
    
    func update(body: String) {
        guard !body.isEmpty else {
            return
        }
        
        let name = String(body.prefix(20))
        
        if let note = note {
            note.update(name: name, body: body)
        } else {
            Note.create(name: name, body: body, creationDate: creationDate, folderObjectId: folderId)
        }
    }
}
