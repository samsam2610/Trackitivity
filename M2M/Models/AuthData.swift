//
//  AuthData.swift
//  M2M
//
//  Created by Victor Zhong on 3/28/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class AuthData {
    private init() {}
    static let auth = AuthData()

    private var loginData: LoginData?

    func setLogin(_ loginInfo: LoginData) {
        loginData = loginInfo
    }

    func getUser() -> LoginData? {
        return loginData
    }

    func getUserID() -> String? {
        guard let userID = loginData?.userID else { return nil }
        return userID
    }

    func clearCredentials() {
        loginData = nil
    }

}
