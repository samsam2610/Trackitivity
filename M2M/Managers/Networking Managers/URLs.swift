//
//  URLs.swift
//  M2M
//
//  Created by Tran Sam on 3/6/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

enum URLpath: String {
    case activity = "/activities"
    case exercise = "/exercises"
    case assignment = "/assignments"
}

struct URLs {
    static let base = URL(string: "https://apiserver269.herokuapp.com/exercise/")
}
