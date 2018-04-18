//
//  doctorViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/26/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import CoreData

class DoctorViewController: UIViewController {
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var window: UIWindow?
    var managedContext: NSManagedObjectContext!
    var controller: NSFetchedResultsController<Dog>!
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
        
        guard let userID = AuthData.auth.getUserID() else { return }
        print("Login data is \(String(describing: userID))")
        
        var getData = RestApiManager()
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
        let dogName = "Fido"
        
        
        let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
        do {
            patients = try managedContext.fetch(dogFetch)
            if patients.count == 0 {
                currentDog = Dog(context: managedContext)
                currentDog?.name = dogName
                try managedContext.save()
            }
            print(patients.count)
            patients = try managedContext.fetch(dogFetch)

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        dogFetch.sortDescriptors = [NSSortDescriptor(key: #keyPath(Dog.name), ascending: false)]
        controller = NSFetchedResultsController(fetchRequest: dogFetch, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)

        controller.delegate = self

        try! controller.performFetch()
    }
}
extension DoctorViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

extension DoctorViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let info: NSFetchedResultsSectionInfo = sections[section]
            return info.numberOfObjects
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let patient = patients[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Patient",
                                                 for: indexPath)
        //        cell.textLabel?.text = patient?.value(forKeyPath: "name") as? String
        cell.textLabel?.text = controller.object(at: indexPath).name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentPatient = patients[indexPath.row]
        let name = currentPatient?.value(forKey: "name") as? String
        let id = currentPatient?.value(forKey: "id") as? Int
        print("name is \(String(describing: name)), and id is \(String(describing: id))")

        // MARK: Save for later
//        let doctorProgressVC = DoctorProgressViewController.instantiate(fromAppStoryboard: .doctorProgressViewController)
//        doctorProgressVC.patientName = name
//        doctorProgressVC.patientID = id
//        self.present(doctorProgressVC, animated: true, completion: nil)
        let assignmentsViewController = AssignmentsViewController.instantiate(fromAppStoryboard: .assignmentsViewController)
        assignmentsViewController.patientID = id
        assignmentsViewController.patientName = name
        self.present(assignmentsViewController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            print("indexpath is \(indexPath)")
            if let object = self?.controller.object(at: indexPath) {
                print("object is \(object.name)")
                self?.managedContext.delete(object)
                try! self?.managedContext.save()
            }
        }

        editAction.backgroundColor = .red

        return [editAction]
    }
}

extension DoctorViewController {
    @IBAction func backToMain(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPatient(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add New Patient",
                                                message: "",
                                                preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
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

