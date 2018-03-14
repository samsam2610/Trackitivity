//
//  TimeInterval+String.swift
//  M2M
//
//  Created by Victor Zhong on 3/14/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

extension TimeInterval {

    func toString(input: TimeInterval) -> (String) {
        let integerTime = Int(input)
        let hours = integerTime / 3600
        let mins = (integerTime / 60) % 60
        let secs = integerTime % 60

        var finalString = ""

        if hours > 0 {
            finalString += "\(hours) hrs, "
        }

        if mins > 0 {
            finalString += "\(mins) mins,"
        }

        if secs > 0 {
            finalString += "\(secs) secs"
        }
        return finalString
    }

}
