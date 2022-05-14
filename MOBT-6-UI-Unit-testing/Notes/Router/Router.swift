//
//  Router.swift
//  Notes
//
//

import UIKit

final class Router {
    private let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func push(_ viewController: UIViewController) {
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func setRootController(_ viewController: UIViewController) {
        UIView.transition(with: rootViewController.view,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.rootViewController.setViewControllers([viewController], animated: false)
                          })
    }
}
