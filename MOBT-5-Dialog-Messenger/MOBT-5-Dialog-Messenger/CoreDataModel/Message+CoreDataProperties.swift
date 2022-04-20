//
//  Message+CoreDataProperties.swift
//  MOBT-5-Dialog-Messenger
//
//  Created by Mykyta Babanin on 12.04.2022.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}

extension Message : Identifiable {

}
