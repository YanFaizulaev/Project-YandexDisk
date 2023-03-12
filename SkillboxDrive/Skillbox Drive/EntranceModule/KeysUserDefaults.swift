//
//  KeysUserDefaults.swift
//  Skillbox Drive
//
//  Created by Bandit on 16.02.2023.
//

import UIKit

enum KeysUserDefaults {
    static let userIsLogged = "userIsLogged"
    static let newUser = "newUser"
    static let tokenUser = "tokenUser"
}

extension UserDefaults {
    @objc dynamic var userIsLogged: Bool {
        return bool(forKey: KeysUserDefaults.userIsLogged)
    }
    @objc dynamic var newUser: Bool {
        return bool(forKey: KeysUserDefaults.newUser)
    }
    @objc dynamic var tokenUser: String {
        return string(forKey: KeysUserDefaults.tokenUser) ?? ""
    }
}

