//
//  Folder+CoreDataClass.swift
//  Notes
//
//
//

import Foundation
import CoreData

enum FolderError: Error {
    case existingFolder
}

enum SortCondition: String {
    case name
    case creationDate
}

@objc(Folder)
public class Folder: NSManagedObject {
        
    static func create(name: String, creationDate: Date, completion: @escaping (Error?) -> Void) {
        Database.shared.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            fetchRequest.fetchLimit = 1

            if let result = try? context.fetch(fetchRequest), !result.isEmpty {
                completion(FolderError.existingFolder)
                
                return
            }

            let folder = Folder(context: context)
            folder.name = name
            folder.creationDate = creationDate

            try? context.save()

            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    static func createFetchedResultsController(sort: SortCondition) -> NSFetchedResultsController<Folder> {
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sort.rawValue, ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: Database.shared.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }
    
    func delete() {
        Database.shared.persistentContainer.performBackgroundTask { context in
            let folder = context.object(with: self.objectID)
            context.delete(folder)
            try? context.save()
        }
    }
}
