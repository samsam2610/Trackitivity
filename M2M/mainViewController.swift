//
//  mainViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import ResearchKit



class mainViewController: UIViewController {

    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            thighMaxAngle = 20
            thighMinAngle = -20
        case "Standing Knee Bends":
            thighMinAngle = 45
            thighMaxAngle = 170
        default:
            thighMaxAngle = 20
            thighMinAngle = -20
        }
        if (workoutActive == false) {
            workoutActive = true
        }
        startTime = NSCalendar.current as NSCalendar
        let practiceVC = practiceViewController.instantiate(fromAppStoryboard: .practiceViewController)
        self.present(practiceVC, animated: true, completion: nil)
    }
    
    @IBAction func exercistList(_ sender: UIButton) {
        let exerciseVC = exerciseViewController.instantiate(fromAppStoryboard: .exerciseViewController)
        self.present(exerciseVC, animated: true, completion: nil)
    }
    
    @IBAction func doctorSetting(_ sender: UIButton) {
        let doctorVC = doctorViewController.instantiate(fromAppStoryboard: .doctorViewController)
        self.present(doctorVC, animated: true, completion: nil)
    }
    
    @IBAction func progressView(_ sender: Any) {
        let progressVC = progressViewController.instantiate(fromAppStoryboard: .progressViewController)
        self.present(progressVC, animated: true, completion: nil)
    }
    
    
    func PostData() {
        
        let parameters = [
            "title": "Partial Squad",
            "description": "",
            "time_start": 1506356064,
            "time_end": 1506359664,
            "duration": 1000,
            "repetitions": 50,
            "average_angle": 60,
            "min_angle": 80,
            "max_angle": 180
            ] as [String : Any]
        
        guard let url = URL(string: "https://apiserver269.herokuapp.com/activities") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    
    func Login() {
        
        let parameters = [
            "email": "lqthinh93@gmail.com",
            "password": "12345678"
            ] as [String : Any]
        
        guard let url = URL(string: "https://apiserver269.herokuapp.com/auth/local") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    
}
