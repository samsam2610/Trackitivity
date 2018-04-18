//
//  String+toDateString.swift
//  M2M
//
//  Created by Victor Zhong on 4/17/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

extension String {
    func toDateString(_ withTime: Bool = true) -> String? {
        let seconds = Int(self)! / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(Double(seconds)))

        let dateFormatter = DateFormatter()
        if withTime {
            dateFormatter.dateFormat =  "MMM dd, yyyy, hh:mm a"
        } else {
            dateFormatter.dateFormat =  "MMM dd, yyyy"
        }
        return dateFormatter.string(from: date)
    }
}
