//
//  Defaults.swift
//  M2M
//
//  Created by Victor Zhong on 3/28/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class Defaults {
    private init() {}
    static let manager = Defaults()
    private let standard = UserDefaults.standard

    func autoFillTextFields() -> (String, String)? {
        if let email = standard.value(forKey: "email") as? String, let password = standard.value(forKey: "password") as? String  {
            return (email, password)
        } else {
            return nil
        }
    }

    func saveToDefaults(_ credentials: PatientCredential) {
        self.standard.set(credentials.email, forKey: "email")
        self.standard.set(credentials.password, forKey: "password")
    }
}
