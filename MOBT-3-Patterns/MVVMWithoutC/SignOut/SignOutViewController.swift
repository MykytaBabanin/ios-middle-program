//
//  MainPageViewController.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit

class SignOutViewController: UIViewController {
    
    var viewModel: SignOutViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel?.titleText
        signOutButtonPresent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisapear()
    }
    
    func signOutButtonPresent() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleSignOut))
    }
    
    @objc func handleSignOut() {
        viewModel?.saveLoggedState()
        viewModel?.displayLogin()
    }
}

