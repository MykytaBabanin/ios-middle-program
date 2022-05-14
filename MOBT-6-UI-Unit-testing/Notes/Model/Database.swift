//
//  Database.swift
//  Notes
//
//

import Foundation
import CoreData

final class Database {
    static let shared = Database()
    
    let persistentContainer = NSPersistentContainer(name: "Notes")
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    func open(completion: @escaping () -> Void) {
        persistentContainer.loadPersistentStores(completionHandler: { [weak self] _, error in
            self?.viewContext.automaticallyMergesChangesFromParent = true
            
            DispatchQueue.main.async(execute: completion)
        })
    }

    private init() { }
}
