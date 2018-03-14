//
//  Double+Rounding.swift
//  M2M
//
//  Created by Victor Zhong on 3/14/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func newAngle() -> Double {
        return Double(360 * (currentCount / targetCount))
    }
}
