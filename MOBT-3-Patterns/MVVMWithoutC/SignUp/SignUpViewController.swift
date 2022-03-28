//
//  SignUpViewController.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 01.07.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpUsernameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpConfirmationTextField: UITextField!
    
    let viewModel: SignUpViewModelProtocol?
    
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
        viewModel?.registerCompletion { [weak self] (status) in
            if status {
                self?.displayLoginPage()
            } else {
                self?.presentMessage("Password do not match")
            }
        }
    }
    
    private func setupBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(displayLoginPage))
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        guard let userName = self.signUpUsernameTextField.text else { return }
        guard let password = self.signUpPasswordTextField.text else { return }
        guard let confirmationPassword = self.signUpConfirmationTextField.text else { return }
        
        viewModel?.registrationUserWith(userName, andPassword: password, confirmationPassword: confirmationPassword)
    }
    
    @objc private func displayLoginPage() {
        viewModel?.tappedLoginScreen()
    }
}
