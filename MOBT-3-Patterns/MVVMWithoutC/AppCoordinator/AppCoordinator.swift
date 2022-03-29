//
//  AppCoordinator.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 21.07.2021.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func childDidFinish(_ childCoordinator: Coordinator)
    func start()
}

final class AppCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let def = UserDefaults.standard
        let is_authenticated = def.bool(forKey: "isLoggedIn")
        let navigationController = UINavigationController()
        
        if is_authenticated {
            let signOutCoordinator = SignOutCoordinator(navigationController: navigationController)
            signOutCoordinator.parentCoordinator = self
            childCoordinators.append(signOutCoordinator)
            signOutCoordinator.start()
        } else {
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            loginCoordinator.parentCoordinator = self
            childCoordinators.append(loginCoordinator)
            loginCoordinator.start()
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool
            in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
