//
//  LoginViewController.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userNameTextField: UITextField!
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisapear()
    }
    
    func setupUI() {
        guard let viewModel = viewModel else { return }
        title = viewModel.navigationTitle
        navigationItem.hidesBackButton = viewModel.isBackButtonInvisible
    }
    
    func bind() {
        viewModel?.loginCompletion { [weak self] (success) in
            guard let self = self else { return }
            if success {
                self.viewModel?.displaySignOut()
            } else {
                self.presentMessage("Wrong credentials")
            }
        }
    }
    
    @IBAction func loginAction() {
        guard let userName = self.userNameTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        viewModel?.authenticateUser(with: userName, password)
    }
    
    @IBAction func signUpAction() {
        viewModel?.displaySignUpPage()
    }
}
