//
//  Note+CoreDataProperties.swift
//  Notes
//
//
//

import Foundation
import CoreData

extension Note {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var folder: Folder?
}
