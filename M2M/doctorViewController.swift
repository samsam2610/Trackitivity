//
//  doctorViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/26/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import CoreData

class doctorViewController: UIViewController {
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var window: UIWindow?
    var managedContext: NSManagedObjectContext!
    var currentDog: Dog?
    var patients: [Dog?] = []
    var jsonData: Data?
    var decodedPerson: Patient?
    var tempName = [Patient]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell_Patient")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.managedContext
        
        let getData = RestApiManager()
        getData.stringURL = "https://my.api.mockaroo.com/static_patient_list.json?key=4d9f5440"
        getData.getPatients { tempData in
            
            print(tempData)
            self.tempName = tempData
            for i in 0..<self.tempName.count {
                if self.tempName[i].stage == true {
                    self.saveNewPatient(name: self.tempName[i].name, id: self.tempName[i].id)
                    print("Added new patient")
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
        do {
            patients = try managedContext.fetch(dogFetch)
            print(patients.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension doctorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = patients.count
        guard count > 1 else {
            return 1
        }
        print("cell count is \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let patient = patients[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Patient",
                                                 for: indexPath)
        cell.textLabel?.text = patient?.value(forKeyPath: "name") as? String
        return cell
    }
    
    
}

extension doctorViewController {
    @IBAction func backToMain(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPatient(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add New Patient",
                                                message: "",
                                                preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let TextField = alertController.textFields?.first as! UITextField
            
            print("firstName \(String(describing: TextField.text))")
            let dogName = TextField.text
            self.saveNewPatient(name: dogName!, id: 1 as Int)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Patient Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveNewPatient(name: String, id: Int) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Dog", in: managedContext)
        let newUser = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        newUser.setValue(name, forKey: "name")
        newUser.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
            patients.append(newUser as? Dog)
        } catch {
            print("Failed saving")
        }
    }
    
}


/*
 To be recyled
 
 @IBOutlet weak var targetRep: UILabel!
 @IBOutlet weak var targetRag: UILabel!
 @IBOutlet weak var targetDur: UILabel!
 @IBOutlet weak var targetRepe: UISlider!
 @IBOutlet weak var targetTim: UISlider!
 @IBOutlet weak var targetRa: UISlider!
 
 
 override func viewDidLoad() {
 self.targetRep.text = "Target Repetitions is \(targetCount) counts"
 self.targetRag.text = "Target Range of Motion is \(targetROM) degrees"
 self.targetDur.text = "Target duration is \(targetTime) seconds"
 self.targetRepe.setValue(Float(targetCount), animated: false)
 self.targetRa.setValue(Float(targetROM), animated: false)
 self.targetTim.setValue(Float(targetTime), animated: false)
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 }
 
 @IBAction func confirmSelection(_ sender: Any) {
 let dialogMessage = UIAlertController(title: "Confirm", message: "The target ROM is \(targetROM), and the target repetitions is \(targetCount)", preferredStyle: .alert)
 
 // Create OK button with action handler
 let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
 self.dismiss(animated: true, completion: nil)
 })
 
 // Create Cancel button with action handlder
 let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
 targetCount = 20
 targetROM = 40
 targetTime = 120
 self.targetRepe.setValue(Float(targetCount), animated: false)
 self.targetRa.setValue(Float(targetROM), animated: false)
 self.targetTim.setValue(Float(targetTime), animated: false)
 self.targetRep.text = "Target Repetitions is \(targetCount) counts"
 self.targetRep.text = "Target Repetitions is \(targetCount) counts"
 self.targetDur.text = "Target duration is \(targetTime) seconds"
 
 
 })
 
 //Add OK and Cancel button to dialog message
 dialogMessage.addAction(confirm)
 dialogMessage.addAction(cancel)
 
 // Present dialog message to user
 self.present(dialogMessage, animated: true, completion: nil)
 
 }
 
 @IBAction func targetRepetition(sender: UISlider ) {
 targetCount = Double(sender.value).rounded(toPlaces: 0)
 self.targetRep.text = "Target Repetitions is \(targetCount) counts"
 
 }
 
 @IBAction func targetRange(sender: UISlider) {
 targetROM = Double(sender.value).rounded(toPlaces: 0)
 self.targetRag.text = "Target ROM is \(targetROM) degrees"
 }
 
 @IBAction func targetDuration(sender: UISlider) {
 targetTime = Double(sender.value).rounded(toPlaces: 0)
 self.targetDur.text = "Target duration is \(targetTime) seconds"
 }
 */

