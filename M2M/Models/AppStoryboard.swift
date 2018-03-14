//
//  AppStoryboard.swift
//  M2M
//
//  Created by Victor Zhong on 3/14/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    /**
     quickly instaniate viewcontroller from different storyboard.

     This is alternative for
     let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
     let loginScene = storyboard.instatiateViewController(withIdentifier: "LoginVC") as LoginVC!
     */
    case practiceViewController = "PracticeViewController",
    mainViewController = "MainViewController",
    doctorViewController = "DoctorViewController",
    bleViewController,
    exerciseViewController = "ExerciseViewController",
    progressViewController = "ProgressViewController",
    progressDetailViewController = "ProgressDetailViewController",
    doctorProgressViewController = "DoctorProgressViewController",
    doctorProgressDetailViewController = "DoctorProgressDetailViewController",
    progressGeneralViewController = "ProgressGeneralViewController",
    exerciseParameterViewController = "ExerciseParameterViewController"

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
