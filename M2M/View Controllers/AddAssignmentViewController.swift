//
//  AddAssignmentsViewController.swift
//  M2M
//
//  Created by Victor Zhong on 4/17/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import UIKit

class AddAssignmentViewController: UIViewController {

    // MARK: - Properties and Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!

    var cellID = "exerciseCell"
    var exercises = [ExerciseData]()
    var selectedExercise: ExerciseData?

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true

        DispatchQueue.main.async {
            self.exercises = SelectedExercise.manager.retrieveExerciseList()
            self.tableView.reloadData()
        }
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        // TODO: Create assignment and send to user

        guard let exerciseToPost = selectedExercise else { return }

        AssignmentAPIHelper.manager.createAssignment(exerciseToPost, patientID: "ebb1f78c-704d-40c5-a1bc-8b024e3956bc", creatorID: "d19c786f-633a-44ba-98ab-0d207592c4cc", completionHandler: { _ in
            self.dismiss(animated: true, completion: nil)
        }, errorHandler: { print($0) })
    }
}

extension AddAssignmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        let exerciseAtRow = exercises[indexPath.row]
        cell.textLabel?.text = exerciseAtRow.exerciseName
        cell.detailTextLabel?.text = exerciseAtRow.description

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExercise = exercises[indexPath.row]
        print("Selected Exercise: \(exercises[indexPath.row].exerciseName), chosen: \(selectedExercise!.exerciseName)")
        doneButton.isEnabled = true
    }
}
