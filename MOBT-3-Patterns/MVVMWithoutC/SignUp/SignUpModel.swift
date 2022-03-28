//
//  SignUpModel.swift
//  MVVMWithoutC
//
//  Created by Mykyta Babanin on 02.07.2021.
//

import UIKit

protocol SignUpModelProtocol {
    var userName: String? { get set }
    var password: String? { get set }
}

struct SignUpModel: SignUpModelProtocol {
    private enum SettingsKeys: String {
        case username
        case password
        case confirmationPassword
    }
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var userName: String? {
        get {
            return defaults.string(forKey: SettingsKeys.username.rawValue)
        } set {
            set(SettingsKeys.username, value: newValue)
        }
    }
    
    var password: String? {
        get {
            return defaults.string(forKey: SettingsKeys.password.rawValue)
        } set {
            set(SettingsKeys.password, value: newValue)
        }
    }
    
    var confirmationPassword: String? { didSet { return } }
    
    private func set(_ field: SettingsKeys, value: String?) {
        let key = field.rawValue
        if let newValue = value {
            print("value: \(newValue) was added to \(key)")
            defaults.set(newValue, forKey: key)            
        } else {
            defaults.removeObject(forKey: key)
        }
    }
}

