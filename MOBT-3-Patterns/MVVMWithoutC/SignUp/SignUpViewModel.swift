//
//  SignUpViewModel.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit

protocol SignUpViewModelProtocol {
    var userName: String { get set }
    var password: String { get set }
    var confirmationPassword: String? { get }
    var coordinator: SignUpCoordinator? { get }
    func registrationUserWith(_ userName: String, andPassword password: String, confirmationPassword: String)
    typealias authenticationLoginCallBack = (_ status: Bool) -> Void
    func registerCompletion(callBack: @escaping (Bool) -> Void)
    func tappedLoginScreen()
    func viewDidDisapear()
}

class SignUpViewModel: SignUpViewModelProtocol {
    typealias authenticationRegistrationCallBack = (_ status: Bool) -> Void
    var registerCallback:authenticationRegistrationCallBack?
    var model: SignUpModelProtocol?
    weak var coordinator: SignUpCoordinator?
    
    var userName: String {
        get {
            guard let userName = model?.userName else { return "" }
            return userName }
        set(newValue) { model?.userName = newValue }
    }
    
    var password: String {
        get { guard let password = model?.password else { return "" }
            return password }
        set(newValue) { model?.password = newValue }
    }
    
    var confirmationPassword: String? { get { return "" } }
    
    func registrationUserWith(_ userName: String, andPassword password: String, confirmationPassword: String) {
        if validateSignUpData(userName: userName, password: password, confirmationPassword: confirmationPassword ) {
            model = SignUpModel()
            self.userName = userName
            self.password = password
            self.registerCallback?(true)
        } else {
            self.registerCallback?(false)
        }
    }
    
    func registerCompletion(callBack: @escaping authenticationRegistrationCallBack) {
        self.registerCallback = callBack
    }
    
    func tappedLoginScreen() {
        coordinator?.startLogin()
    }
    
    func viewDidDisapear() {
        coordinator?.didFinishSignUp()
    }
    
    private func validateSignUpData(userName: String, password: String,  confirmationPassword: String) -> Bool {
        return isValidEmail(userName) &&
        isValidPassword(password) &&
        isValidPassword(confirmationPassword) && password == confirmationPassword
    }
}
