//
//  Note+CoreDataClass.swift
//  Notes
//
//
//

import Foundation
import CoreData

enum NoteError: Error {
    case existingNote
}

@objc(Note)
public class Note: NSManagedObject {
    static func create(name: String, body: String, creationDate: Date, folderObjectId: NSManagedObjectID) {
        Database.shared.persistentContainer.performBackgroundTask { context in
            guard let folder = context.object(with: folderObjectId) as? Folder else { return }
            
            let note = Note(context: context)
            note.body = body
            note.name = name
            note.creationDate = creationDate
            note.folder = folder
            
            try? context.save()
        }
    }
    
    static func createFetchedResultsController(sort: SortCondition, folderId: NSManagedObjectID) -> NSFetchedResultsController<Note> {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sort.rawValue, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "folder == %@", folderId)
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: Database.shared.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }
    
    func update(name: String, body: String) {
        Database.shared.persistentContainer.performBackgroundTask { context in
            guard let note = context.object(with: self.objectID) as? Note else { return }
            note.body = body
            note.name = name
            try? context.save()
        }
    }
    
    func delete() {
        Database.shared.persistentContainer.performBackgroundTask { context in
            let note = context.object(with: self.objectID)
            context.delete(note)
            try? context.save()
        }
    }
}
