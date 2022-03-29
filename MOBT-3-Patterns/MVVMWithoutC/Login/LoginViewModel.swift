//
//  LoginViewModel.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import Foundation


protocol LoginViewModelProtocol {
    var userName: String { get }
    var password: String { get }
    func authenticateUser(with userName: String, _ password: String)
    func verifyUser(with userName: String, _ password: String)
    func displaySignUpPage()
    func displaySignOut()
    func viewDidDisapear()
}

class LoginViewModel: LoginViewModelProtocol {
    weak var coordinator: LoginCoordinator?
    private let defaults: UserDefaults
    let model: LoginModel
    
    var navigationTitle: String {
        return "Login Page"
    }
    
    var isBackButtonInvisible: Bool {
        return true
    }
    
    var userName: String {
        return model.userName ?? ""
    }
    
    var password: String {
        return model.password ?? ""
    }
    
    typealias authenticationLoginCallBack = (_ status: Bool) -> Void
    var loginCallback:authenticationLoginCallBack?
    
    init(defaults: UserDefaults = .standard, model: LoginModel) {
        self.defaults = defaults
        self.model = model
    }
    
    func authenticateUser(with userName: String, _ password: String) {
        if !userName.isEmpty {
            if !password.isEmpty {
                self.verifyUser(with: userName, password)
            } else {
                self.loginCallback?(false)
            }
        } else {
            self.loginCallback?(false)
        }
    }
    
    func verifyUser(with userName: String, _ password: String) {
        if userName == userName && password == password {
            saveLoggedState()
            self.loginCallback?(true)
        } else {
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
