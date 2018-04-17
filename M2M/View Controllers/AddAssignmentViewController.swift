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

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        // TODO: Create assignment and send to user

//        AssignmentAPIHelper.manager.postAssignment(<#T##assignment: Assignment##Assignment#>, id: <#T##String?#>, completionHandler: <#T##(Data) -> Void#>, errorHandler: <#T##(AppError) -> Void#>)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddAssignmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        let exerciseAtRow = exercises[indexPath.row]
        cell.textLabel?.text = exerciseAtRow.exerciseName

        return cell
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        doneButton.isEnabled = true
    }
}
