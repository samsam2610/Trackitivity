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
    @IBOutlet weak var progressPer: UILabel!
    
    static func storyboardInstance() -> progressDetailViewController? {
        let storyboard: UIStoryboard = UIStoryboard(name: String(describing: progressDetailViewController.self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? progressDetailViewController
    }

    var practiceResult: Walk!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.exerciseName.text = selectedExercise
        let startDate = practiceResult.startDate as Date?
        let endDate = practiceResult.endDate as Date?
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([ .second])
        let dateComponents = calendar.dateComponents(unitFlags, from: startDate!, to: endDate!)
        let seconds = dateComponents.second
        self.durationVar.text = String(describing: seconds)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}