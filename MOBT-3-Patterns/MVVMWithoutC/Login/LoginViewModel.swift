//
//  LoginViewModel.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import Foundation


protocol LoginViewModelProtocol {
    typealias authenticationLoginCallBack = (_ status: Bool) -> Void
    var modelUserName: String { get }
    var modelPassword: String { get }
    func authenticationUserWith(userName: String, andPassword password: String)
    func verifyUserWith(_ userName: String, andPassword password: String)
    func loginCompletion(callBack: @escaping authenticationLoginCallBack)
    func displaySignUpPage()
    func displaySignOut()
    func viewDidDisapear()
}

class LoginViewModel: LoginViewModelProtocol {
    weak var coordinator: LoginCoordinator?
    let defaults: UserDefaults
    let model: LoginModel
    
    var modelUserName: String {
        get {
            guard let userName = model.userName else { return "" }
            return userName }
    }
    
    var modelPassword: String {
        get {
            guard let password = model.password else { return "" }
            return password }
    }
    
    typealias authenticationLoginCallBack = (_ status: Bool) -> Void
    var loginCallback:authenticationLoginCallBack?
    
    init(defaults: UserDefaults = .standard, model: LoginModel) {
        self.defaults = defaults
        self.model = model
    }
    
    func authenticationUserWith(userName: String, andPassword password: String) {
        if userName.count != 0 {
            if password.count != 0 {
                self.verifyUserWith(userName, andPassword: password)
            } else {
                self.loginCallback?(false)
            }
        } else {
            self.loginCallback?(false)
        }
    }
    
    func verifyUserWith(_ userName: String, andPassword password: String) {
        if userName == modelUserName && password == modelPassword {
            saveLoggedState()
            self.loginCallback?(true)
        } else {
            print(modelUserName)
            print(modelPassword)
            self.loginCallback?(false)
        }
    }
    
    func saveLoggedState() {
        defaults.set(true, forKey: "isLoggedIn")
        defaults.synchronize()
    }
    
    func loginCompletion(callBack: @escaping (Bool) -> Void) {
        self.loginCallback = callBack
    }
    
    func displaySignUpPage() {
        coordinator?.startSignUp()
    }
    
    func displaySignOut() {
        coordinator?.startSignOut()
    }
    
    func viewDidDisapear() {
        coordinator?.didFinishLogin()
    }
}
