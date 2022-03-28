//
//  LoginModel.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 07.07.2021.
//

import Foundation

protocol LoginModelProtocol {
    var userName: String? { get }
    var password: String? { get }
}

class LoginModel: LoginModelProtocol {
    enum SettingsKey: String {
        case username 
        case password
    }
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var userName: String? {
        return defaults.string(forKey: SettingsKey.username.rawValue)
    }
    
    var password: String? {
        return defaults.string(forKey: SettingsKey.password.rawValue)
    }
}
