//
//  MainViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import ResearchKit

class MainViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (connected) {
            connectButton.backgroundColor = UIColor.init(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
            connectButton.setTitle("Connected", for: UIControlState.normal)

        } else {
            connectButton.backgroundColor = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            connectButton.setTitle("No connected device", for: UIControlState.normal)
        }
    }
    
    @IBAction func connectBLE(_ sender: UIButton) {
        if (connected) {
        } else {
            self.present(bleVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        switch selectedExercise {
        case "Sitting Supported Knee Bends":
            thighMaxAngle = 26*2
            thighMinAngle = 0
        case "Standing Knee Bends":
            thighMinAngle = 26*2+1
            thighMaxAngle = 90
        default:
            thighMaxAngle = 26*2
            thighMinAngle = 0
        }
        if (workoutActive == false) {
            workoutActive = true
        }
        startTime = NSCalendar.current as NSCalendar
        let practiceVC = PracticeViewController.instantiate(fromAppStoryboard: .practiceViewController)
        self.present(practiceVC, animated: true, completion: nil)
    }
    
    @IBAction func exercistList(_ sender: UIButton) {
        let exerciseVC = ExerciseViewController.instantiate(fromAppStoryboard: .exerciseViewController)
        self.present(exerciseVC, animated: true, completion: nil)
    }
    
    @IBAction func doctorSetting(_ sender: UIButton) {
        let doctorVC = DoctorViewController.instantiate(fromAppStoryboard: .doctorViewController)
        self.present(doctorVC, animated: true, completion: nil)
    }
    
    @IBAction func progressView(_ sender: Any) {
        //let progressVC = progressViewController.instantiate(fromAppStoryboard: .progressViewController)
        // self.present(progressVC, animated: true, completion: nil)
        let progressGeneralVC =
        ProgressGeneralViewController.instantiate(fromAppStoryboard: .progressGeneralViewController)
        self.present(progressGeneralVC, animated: true, completion: nil)
    }
    

    @IBAction func chatView(_ sender: Any) {
    }

    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            
        }

    }


    
    
}
