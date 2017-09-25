//
//  mainViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
var connected: Bool = false

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
    
    @IBAction func connectBLE(_ sender: Any) {
        if (connected) {
        } else {
            performSegue(withIdentifier: "toBle", sender: AnyObject.self)
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        performSegue(withIdentifier: "toExercise", sender: AnyObject.self)
        if (workoutActive == false) {
        workoutActive = true
        }
        startTime = NSCalendar.current as NSCalendar
    }
    
    
    
}
