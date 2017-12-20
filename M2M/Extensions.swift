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

import Foundation
import UIKit


enum AppStoryboard : String {
/**
     quickly instaniate viewcontroller from different storyboard.
     
     This is alternative for
     let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
     let loginScene = storyboard.instatiateViewController(withIdentifier: "LoginVC") as LoginVC!
 */
    case practiceViewController, mainViewController, doctorViewController, bleViewController, exerciseViewController, progressViewController, progressDetailViewController, doctorProgressViewController, doctorProgressDetailViewController
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        print("SI")
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
        
        // return String(reflecting: self).components(separatedBy: ".").last!
        // return "\(type(of:self))".components(separatedBy: ".").first!
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}


