//
//  MainPageViewController.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit

fileprivate enum Consts {
    static let signOutTitle = "Sign Out"
}

class SignOutViewController: UIViewController {
    
    var viewModel: ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Consts.signOutTitle
        signOutButtonPresent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisapear()
    }
    
    func signOutButtonPresent() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Consts.signOutTitle,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleSignOut))
    }
    
    @objc func handleSignOut() {
        viewModel.saveLoggedState()
        viewModel.displayLogin()
    }
}

