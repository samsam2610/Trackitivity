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
    @IBOutlet weak var tableView: UITableView!

    var assignments = [Assignment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Functions and Methods
}

extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let assignmentAtRow = assignments[indexPath.row]

        cell.textLabel?.text = assignmentAtRow.therapistComment
//        cell.detailTextLabel.text = assignmentAtRow.scoredDate

        return cell
    }
}
