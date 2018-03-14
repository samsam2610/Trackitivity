//
//  progressDetailViewController.swift
//  M2M
//
//  Created by Tran Sam on 11/30/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import CoreData

class progressDetailViewController: UIViewController {

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var durationVar: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var repNumber: UILabel!
    @IBOutlet weak var angleDegree: UILabel!
    

    var practiceResult: Walk!
    var exerciseID: String!
    var repetitions: Int16!
    var avgAngle: Float!
    var duration: String!
    var start: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.exerciseName.text = selectedExercise
//        let startDate = practiceResult.startDate
//        let endDate = practiceResult.endDate
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.maximumUnitCount = 1
//        let interval = formatter.string(from: startDate! as Date!, to: endDate as Date!)
        
        self.durationVar.text = "Duration: \(duration!)"
        self.exerciseName.text = "Exercise name: \(exerciseID!)"
        self.startDate.text = "Date: \(start!)"
        self.repNumber.text = "Repetitions: \(repetitions!)"
        self.angleDegree.text = "Average ROM: \(avgAngle!)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension progressDetailViewController {
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
