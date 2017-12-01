//
//  ExerciseViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/24/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class exerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    static func storyboardInstance() -> exerciseViewController? {
        let storyboard: UIStoryboard = UIStoryboard(name: String(describing: exerciseViewController.self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? exerciseViewController
    }
    
    let mainVC = mainViewController.storyboardInstance()
    
    @IBOutlet weak var exerciseList: UITableView!
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.present(mainVC!, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "You selected \(selectedExercise). Do you want to continue?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            self.present(self.mainVC!, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExercise = exercise[indexPath.row]
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
