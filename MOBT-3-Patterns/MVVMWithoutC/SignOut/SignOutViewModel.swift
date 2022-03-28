//
//  SignOutViewModel.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 09.07.2021.
//

import Foundation
import Alamofire

protocol ViewModelProtocol {
    func displayLogin()
    func viewDidDisapear()
    func saveLoggedState()
}

class SignOutViewModel: ViewModelProtocol {
    
    weak var coordinator: signOutCoordinator?
    
    func saveLoggedState() {
        let def = UserDefaults.standard
        def.set(false, forKey: "isLoggedIn")
        def.synchronize()
    }
    
    func displayLogin() {
        coordinator?.startLogin()
    }
    
    func viewDidDisapear() {
        coordinator?.didFinishSignOut()
    }
}


