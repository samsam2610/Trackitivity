//
//  progressDoctorViewController.swift
//  M2M
//
//  Created by Tran Sam on 12/19/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import CoreData

class doctorProgressViewController: UIViewController {

    var patientName: String?
    var patientID: Int?
    var managedContext: NSManagedObjectContext!
    var patientData = [PatientData]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell_Data")
        
        print("Patient name is \(String(describing: patientName))")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.managedContext
        
        let auth = authData.auth
        let userID = auth.loginData?.userID
        
        var getData = RestApiManager()
        let userAction = UserAction.activity
        getData.stringURL = String(describing: getData.createURLWithString(userID: userID!, userAction: userAction.rawValue)!)
        print(getData.stringURL)
        getData.getPatientData { tempData in
            
            print(tempData)
            self.patientData = tempData

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension doctorProgressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = patientData.count
        guard count > 1 else {
            return 1
        }
        print("cell count is \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = patientData.count
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Data",
                                                 for: indexPath)
        guard count > 1 else {
            cell.textLabel?.text = "Loading data"
            return cell
        }
        
        let patient = patientData[indexPath.row]
        print(patient)

        let time = Date(timeIntervalSince1970: Double(patient.timeStart)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let start = dateFormatter.string(from: time)
        cell.textLabel?.text = start
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patient = patientData[indexPath.row]
        let startDate = Date(timeIntervalSince1970: Double(patient.timeStart)!)
        let endDate = Date(timeIntervalSince1970: Double(patient.timeEnd)!)
        let interval = intervalCalculate(startDate: startDate as NSDate, endDate: endDate as NSDate)
        let progressDetailVC = progressDetailViewController.instantiate(fromAppStoryboard: .progressDetailViewController)
        progressDetailVC.exerciseID = patient.exerciseName
        progressDetailVC.duration = interval
        progressDetailVC.avgAngle = Float(patient.averageAngle)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let duration = dateFormatter.string(from: startDate)
        print(duration)
        progressDetailVC.start = duration
        progressDetailVC.repetitions = Int16(patient.repetitions)
        self.present(progressDetailVC, animated: true, completion: nil)
    }
    
    
}

extension doctorProgressViewController {
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func intervalCalculate(startDate: NSDate, endDate: NSDate) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.maximumUnitCount = 1
        let interval = formatter.string(from: startDate as Date!, to: endDate as Date!)
        return interval!
    }
}
