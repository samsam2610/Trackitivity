//
//  Extensions.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

//extension UIViewController {
//    var appDelegate: AppDelegate{
//        return UIApplication.shared.delegate as! AppDelegate
//    }
//}

func newAngle() -> Double {
    return Double(360 * (currentCount / targetCount))
}



