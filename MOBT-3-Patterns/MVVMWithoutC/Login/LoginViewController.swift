//
//  LoginViewController.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var viewModel: LoginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login Page"
        navigationItem.hidesBackButton = true
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisapear()
    }
    
    func bind() {
        viewModel?.loginCompletion { [weak self] (status) in
            guard let self = self else { return }
            if status {
                self.viewModel?.displaySignOut()
            } else {
                self.presentMessage("Wrong credentials")
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let userName = self.userNameTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        viewModel?.authenticationUserWith(userName: userName, andPassword: password)
    }
   
    @IBAction func signUpAction(_ sender: Any) {
        viewModel?.displaySignUpPage()
    }
}
