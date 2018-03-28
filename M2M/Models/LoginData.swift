//
//  LoginData.swift
//  M2M
//
//  Created by Victor Zhong on 3/28/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

struct LoginData: Codable {
    var userID: String
    var email: String

    private enum CodingKeys: String, CodingKey {
        case userID = "id"
        case email
    }
}
