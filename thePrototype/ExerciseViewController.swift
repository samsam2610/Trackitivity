//
//  ExerciseViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/24/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var exerciseList: UITableView!
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "backToMainFromExercise", sender: AnyObject.self)
    }
    let exercise = ["Partial Squad", "Straight Leg Raises"]
    var descrip = ["Hold onto a sturdy chair or counter with your feet 6-12 inches from the chair or counter. While keeping your back straight, slowly bend your knees. DO NOT go any lower than 90 degrees. Hold for 5-10 seconds. Slowly come back up. Relax.","Support yourself, if necessary, and slowly lift your involved leg forward keeping your knee straight. Return to the starting position"]
     //var descrip = ["Yo","Yo"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (exercise.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseList", for: indexPath) as! ExerciseTableViewCell
        
        cell.demoImage.image = UIImage(named: (exercise[indexPath.row]))
        cell.demoInfo.text = descrip[indexPath.row]
        cell.demoName.text = exercise[indexPath.row]
        
        return (cell)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
