//
//  ExerciseViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/24/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    @IBAction func exerciseAdd(_ sender: UIButton) {
        let exerciseParameterVC = ExerciseParameterViewController.instantiate(fromAppStoryboard: .exerciseParameterViewController)
        self.present(exerciseParameterVC, animated: true, completion: nil)
    }
    
//    @IBOutlet weak var exerciseList: UITableView!

        //var descrip = ["Yo","Yo"]
    var exercises: [ExerciseData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addButton.layer.cornerRadius = 40
        addButton.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        ExerciseAPIHelper.manager.getExercises(AuthData.auth.getUserID()!, completionHandler: { (exercises) in
            DispatchQueue.main.async {
                self.exercises = exercises
                self.tableView.reloadData()
            }
        }, errorHandler: { (error) in
            print(error.localizedDescription)
        })
    }

    func selectedAnnouncement(_ exercise: ExerciseData) {
        let alert = UIAlertController(title: nil, message: "\(exercise.exerciseName) selected!", preferredStyle: .alert)
        let alertActions = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertActions)
        self.present(alert, animated: true, completion: nil)
    }

}

//extension exerciseViewController: UITableViewDataSource, UITableViewDelegate {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return (exercise.count)
//    }
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseList", for: indexPath) as! ExerciseTableViewCell
//        
//        cell.demoImage.image = UIImage(named: (exercise[indexPath.row]))
//        cell.demoInfo.text = descrip[indexPath.row]
//        cell.demoName.text = exercise[indexPath.row]
//        
//        return (cell)
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedExercise = exercise[indexPath.row]
//        selectedExerciseID = exerciseID[indexPath.row]
//    }
//    
//
//}

extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell")! as UITableViewCell

        let exerciseAtRow = exercises[indexPath.row]

        cell.textLabel?.text = exerciseAtRow.exerciseName

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciseAtRow = exercises[indexPath.row]
        
        print("Exercise Selected: \(exerciseAtRow.exerciseName), \(exerciseAtRow.id)")
        dump(exerciseAtRow)

        SelectedExercise.manager.chooseExercise(exerciseAtRow)
        selectedAnnouncement(exerciseAtRow)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { [weak self] (_, indexPath) in
            let exerciseAtRow = self?.exercises[indexPath.row]

            print("Exercise Selected: \(exerciseAtRow?.exerciseName), \(exerciseAtRow?.id)")
            dump(exerciseAtRow)

            let exerciseParameterVC = ExerciseParameterViewController.instantiate(fromAppStoryboard: .exerciseParameterViewController)
            exerciseParameterVC.passedExercise = exerciseAtRow

            self?.present(exerciseParameterVC, animated: true, completion: nil)
        }

        editAction.backgroundColor = .red

        return [editAction]
    }
}

extension ExerciseViewController {

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIButton) {
        
//        let dialogMessage = UIAlertController(title: "Confirm", message: "You selected \(selectedExercise). Do you want to continue?", preferredStyle: .alert)
//
//        // Create OK button with action handler
//        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
//            self.dismiss(animated: true, completion: nil)
//        })
//
//        // Create Cancel button with action handlder
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
//        })
//
//        //Add OK and Cancel button to dialog message
//        dialogMessage.addAction(confirm)
//        dialogMessage.addAction(cancel)
//
//        // Present dialog message to user
//        self.present(dialogMessage, animated: true, completion: nil)
    }

}
