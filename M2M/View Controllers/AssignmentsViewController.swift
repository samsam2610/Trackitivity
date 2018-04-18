//
//  AssignmentsViewController.swift
//  M2M
//
//  Created by Victor Zhong on 4/11/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import UIKit

class AssignmentsViewController: UIViewController {
    // MARK: - Properties and Outlets
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    let cellID = "assignmentCell"
    var assignments = [Assignment]()
    var patientName: String!
    var accessorID: String!
    var accessLevel = AssignmentAccessor.therapist

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.patientNameLabel.text = "Assigned to patient: \(patientName!)"

        if accessLevel == .patient {
            addButton.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        let completion = { (assignments: [Assignment]) in
            DispatchQueue.main.async {
                self.assignments = assignments
                self.tableView.reloadData()
            }
        }

        AssignmentAPIHelper.manager.getAssignments(accessorID, accessLevel, completionHandler: completion, errorHandler: { print($0) })
    }

    // MARK: - Functions and Methods
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        // TODO: Add segue function and pass on credentials
        let addAssignmentsVC = AddAssignmentViewController.instantiate(fromAppStoryboard: .addAssignmentViewController)
        self.present(addAssignmentsVC, animated: true, completion: nil)
    }

    func selectedAnnouncement(_ exercise: ExerciseData) {
        let alert = UIAlertController(title: nil, message: "\(exercise.exerciseName) selected!", preferredStyle: .alert)
        let alertActions = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertActions)
        self.present(alert, animated: true, completion: nil)
    }

}

extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let assignmentAtRow = assignments[indexPath.row]
        var exerciseString = assignmentAtRow.therapistComment

        if assignmentAtRow.activities.count > 0 {
            exerciseString += " - Completed \(assignmentAtRow.timeModified.toDateString(false)!)"
        } else {
            exerciseString += " - Incomplete"
        }

        cell.textLabel?.text = exerciseString
        cell.detailTextLabel?.text = assignmentAtRow.timeCreated.toDateString()!

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignmentAtRow = assignments[indexPath.row]

        if accessLevel == .patient, assignmentAtRow.activities.count == 0 {
            SelectedAssignment.manager.setAssignment(assignmentAtRow.id)
            if SelectedExercise.manager.chooseExerciseByAssignment(assignmentAtRow.exerciseID) {
                selectedAnnouncement(SelectedExercise.manager.getSelectedExercise()!)
            }
        }
    }
}
