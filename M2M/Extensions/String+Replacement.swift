//
//  String+Replacement.swift
//  M2M
//
//  Created by Victor Zhong on 3/14/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

extension String {
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
