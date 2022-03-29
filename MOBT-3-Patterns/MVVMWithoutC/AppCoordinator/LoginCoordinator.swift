//
//  LoginCoordinator.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 21.07.2021.
//

import UIKit

final class LoginCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController()
        let loginModel = LoginModel()
        let loginViewModel = LoginViewModel(model: loginModel)
        loginViewModel.coordinator = self
        loginViewController.viewModel = loginViewModel
        navigationController.setViewControllers([loginViewController], animated: true)
    }
    
    func startSignUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        signUpCoordinator.parentCoordinator = self
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }
    
    func startSignOut() {
        let signOutCoordinator = SignOutCoordinator(navigationController: navigationController)
        signOutCoordinator.parentCoordinator = self
        childCoordinators.append(signOutCoordinator)
        signOutCoordinator.start()
    }
    
    func didFinishLogin() {
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
