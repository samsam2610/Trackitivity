//
//  LogHelper.swift
//  M2M
//
//  Created by Tran Sam on 6/11/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

func DLog(_ message: String, function: String = #function) {
    #if DEBUG
    NSLog("%@, %@", function, message)
    #endif
}
