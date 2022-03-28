//
//  WeatherCoordinator.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 21.07.2021.
//

import UIKit

final class signOutCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signOutViewController = SignOutViewController()
        let signOutViewModel = SignOutViewModel()
        signOutViewModel.coordinator = self
        signOutViewController.viewModel = signOutViewModel
        navigationController.setViewControllers([signOutViewController], animated: true)
    }
    
    func startLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func didFinishSignOut() {
        parentCoordinator?.childDidFinish(self)
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
