//
//  CustomTabBarController.swift
//  MOBT-5-Dialog-Messenger
//
//  Created by Mykyta Babanin on 14.04.2022.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let friendsViewController = FriendsViewController(collectionViewLayout: layout)
        let recentMessengesNavController = UINavigationController(rootViewController: friendsViewController)
        recentMessengesNavController.tabBarItem.title = "Recent"
        recentMessengesNavController.tabBarItem.image = UIImage(named: "recent")
        
        let callController = createDummyNavControllerWithTitle(title: "Calls", imageName: "calls")
        let groupsController = createDummyNavControllerWithTitle(title: "Groups", imageName: "groups")
        let peopleController = createDummyNavControllerWithTitle(title: "People", imageName: "people")
        let settingsController = createDummyNavControllerWithTitle(title: "Settings", imageName: "settings")
        
        viewControllers = [recentMessengesNavController, callController, groupsController, peopleController, settingsController]
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
