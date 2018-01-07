//
//  ExerciseViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/24/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class exerciseViewController: UIViewController {
    
    @IBOutlet weak var exerciseList: UITableView!

        //var descrip = ["Yo","Yo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension exerciseViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExercise = exercise[indexPath.row]
        selectedExerciseID = exerciseID[indexPath.row]
    }
    

}

extension exerciseViewController {

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "You selected \(selectedExercise). Do you want to continue?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(confirm)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }

}
