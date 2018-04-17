//
//  String+toDateString.swift
//  M2M
//
//  Created by Victor Zhong on 4/17/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

extension String {
    func toDateString() -> String? {
        let date = Date(timeIntervalSince1970: TimeInterval(self)!)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MMM dd, hh:mm a"

        return dateFormatter.string(from: date)
    }
}
