//
//  SignUpViewController.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var signUpUsernameTextField: UITextField!
    @IBOutlet private weak var signUpPasswordTextField: UITextField!
    @IBOutlet private weak var signUpConfirmationTextField: UITextField!
    
    var viewModel: SignUpViewModelProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up"
        bind()
        setupBackButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisapear()
    }
    
    func bind() {
        viewModel?.registerCompletion { [weak self] (success) in
            if success {
                self?.displayLoginPage()
            } else {
                self?.presentMessage("Password do not match")
            }
        }
    }
    
    private func setupBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(displayLoginPage))
    }
    
    @IBAction func signUpAction() {
        guard let userName = self.signUpUsernameTextField.text else { return }
        guard let password = self.signUpPasswordTextField.text else { return }
        guard let confirmationPassword = self.signUpConfirmationTextField.text else { return }

        viewModel?.registrationUserWith(userName, andPassword: password, confirmationPassword: confirmationPassword)
    }
    
    @objc private func displayLoginPage() {
        viewModel?.tappedLoginScreen()
    }
}
