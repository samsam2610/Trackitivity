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

        var idString = ""
        if accessLevel == .therapist {
            idString = "d19c786f-633a-44ba-98ab-0d207592c4cc"
        } else {
            idString = "ebb1f78c-704d-40c5-a1bc-8b024e3956bc"
        }

        AssignmentAPIHelper.manager.getAssignments(accessorID, accessLevel, completionHandler: completion, errorHandler: { print($0) })
//        AssignmentAPIHelper.manager.getAssignments(String(patientID), .therapist, completionHandler: completion, errorHandler: { print($0) })
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
            exerciseString += " - Completed \(assignmentAtRow.timeModified!.toDateString(false)!)"
        } else {
            exerciseString += " - Incomplete"
        }

        cell.textLabel?.text = exerciseString
        cell.detailTextLabel?.text = assignmentAtRow.timeCreated.toDateString()!

        return cell
    }
}
