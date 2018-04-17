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

    let cellID = "assignmentCell"
    var assignments = [Assignment]()
    var patientName: String!
    var patientID: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.patientNameLabel.text = "Assigned to patient: \(patientName!)"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        let completion = { (assignments: [Assignment]) in
            DispatchQueue.main.async {
                self.assignments = assignments
                self.tableView.reloadData()
            }
        }
        
        AssignmentAPIHelper.manager.getAssignments(String(patientID), completionHandler: completion, errorHandler: { print($0) })
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

        cell.textLabel?.text = assignmentAtRow.therapistComment
        cell.detailTextLabel?.text = assignmentAtRow.timeCreated.toDateString()!

        return cell
    }
}
