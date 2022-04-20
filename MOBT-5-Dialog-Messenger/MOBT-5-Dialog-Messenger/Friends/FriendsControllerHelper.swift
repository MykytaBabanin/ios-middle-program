//
//  FriendsControllerHelper.swift
//  MOBT-5-Dialog-Messenger
//
//  Created by Mykyta Babanin on 12.04.2022.
//

import UIKit
import CoreData


extension FriendsViewController {
    private enum Consts {
        static let entityFriendName: String = "Friend"
        static let entityMessageName: String = "Message"
    }
        
    func setupData() {
        clearData()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let mark = createUser(entityName: Consts.entityFriendName,
                                  userName: "Mark",
                                  profileImage: "zuckprofile",
                                  chatMessage: "Hello, vvvvvvvvvvvvv",
                                  minutesAgo: 10,
                                  context: context)
            
            let gandhi = createUser(entityName: Consts.entityFriendName,
                                    userName: "Gandhi",
                                    profileImage: "lordprofile",
                                    chatMessage: "Hello, my name is Gandhidsadsadsadsadsadsadsadsadsadsadsadsadsadsadas",
                                    minutesAgo: 5,
                                    context: context)
            
            let steve = createUser(entityName: Consts.entityFriendName,
                                   userName: "Steve Jobs",
                                   profileImage: "steveprofile",
                                   chatMessage: "Hello, my name is Steve",
                                   minutesAgo: 5,
                                   context: context)
            createMessage(with: "fsafsafasfasfasfsafsafasfsafsafsafsa", friend: steve, minutesAgo: 20, context: context)
            createMessage(with: "afsfsafasfsafsafsafsafasfsa", friend: mark, minutesAgo: 10, context: context)
            createMessage(with: "Hello, my name is Gandhidsadsadsadsadsadsadsadsadsadsadsadsadsadsadas", friend: gandhi, minutesAgo: 5, context: context)
            do {
                try (context.save())
            } catch let err {
                print(err)
            }
            messages = messages?.sorted(by: {$0.date?.compare($1.date!) == .orderedDescending })
        }
        loadData()
    }
    
    private func createUser(entityName: String,
                            userName: String,
                            profileImage: String,
                            chatMessage: String,
                            minutesAgo: Double,
                            context: NSManagedObjectContext) -> Friend {
        let user = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Friend
        guard let user = user else { return Friend() }
        user.name = userName
        user.profileImageName = profileImage
        createMessage(with: chatMessage, friend: user, minutesAgo: minutesAgo, context: context)
        return user
    }
    
    private func createMessage(with text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) {
        let messageSteve = NSEntityDescription.insertNewObject(forEntityName: Consts.entityMessageName, into: context) as! Message
        messageSteve.friend = friend
        messageSteve.text = text
        messageSteve.date = Date().addingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                messages = [Message]()
                for friend in friends {
                    guard let friendName = friend.name else { return }
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Consts.entityMessageName)
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friendName)
                    fetchRequest.fetchLimit = 1
                    do {
                        let fetchedMessages = try context.fetch(fetchRequest) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                    } catch let err {
                        print(err)
                    }
                }
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Consts.entityFriendName)
            do {
                return try (context.fetch(request)) as? [Friend]
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
    private func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            do {
                let entityNames = [Consts.entityFriendName, Consts.entityMessageName]
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    guard let objects = objects else { return }
                    for object in objects {
                        context.delete(object)
                    }
                }
                try(context.save())
            } catch let err{
                print(err)
            }
        }
    }
}
