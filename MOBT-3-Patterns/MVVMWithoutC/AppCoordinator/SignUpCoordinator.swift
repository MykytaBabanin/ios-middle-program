//
//  SignUpCoordinator.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 21.07.2021.
//

import UIKit


final class SignUpCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signUpViewController = SignUpViewController()
        let signUpViewModel = SignUpViewModel()
        signUpViewModel.coordinator = self
        signUpViewController.viewModel = signUpViewModel
        navigationController.setViewControllers([signUpViewController], animated: true)
    }
    
    func startLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func didFinishSignUp() {
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
