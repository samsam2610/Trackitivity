//
//  AppError.swift
//  M2M
//
//  Created by Victor Zhong on 3/21/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

public enum AppError: Error {
    case badData
    case badImageData
    case badImageURL(string: String)
    case badStatusCode(num: Int)
    case badURL(string: String)
    case couldNotParseJSON(rawError: Error)
    case noInternet
    case other(rawError: Error)
}
