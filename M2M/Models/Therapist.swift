//
//  Therapist.swift
//  M2M
//
//  Created by Victor Zhong on 3/28/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

struct TherapistCredential: Codable {
    var email: String
    var password: String

    private enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
    }
}

struct Therapist: Codable {
    let name: String
    let id: Int
}
