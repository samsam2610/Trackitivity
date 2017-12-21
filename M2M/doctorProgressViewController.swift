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
        
        let getData = RestApiManager()
        getData.stringURL = "https://my.api.mockaroo.com/sam.json?key=4d9f5440"
        getData.getPatientData { tempData in
            
            print(tempData)
            self.patientData = tempData

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
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
        cell.textLabel?.text = String(describing: time)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
