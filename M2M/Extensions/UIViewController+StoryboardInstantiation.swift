//
//  UIViewController+StoryboardInstantiation.swift
//  M2M
//
//  Created by Victor Zhong on 3/14/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import UIKit

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
