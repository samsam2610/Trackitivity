//
//  ProgressGeneralViewController.swift
//  
//
//  Created by Tran Sam on 12/24/17.
//

import UIKit
import CoreData

class ProgressGeneralViewController: UIViewController {
    fileprivate let progressCellIdentifier = "progressCellReuseIdentifier"
    var managedContext: NSManagedObjectContext!
    var patientData = [PatientData]()
    var fetchedResultsController : NSFetchedResultsController<Walk>!
    var exerciseInfo: [String: String] = [:]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        for (index, element) in exerciseID.enumerated()
        {
            exerciseInfo[element] = exercise[index]
        }
        print(exerciseInfo)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        managedContext = appDelegate.managedContext
        
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        let exerciseSort = NSSortDescriptor(key: #keyPath(Walk.exerciseID), ascending: true)
        let repetitionSort = NSSortDescriptor(key: #keyPath(Walk.repetition), ascending: false)
        let endDateSort = NSSortDescriptor(key: #keyPath(Walk.endDate), ascending: true)
        let predicate = NSPredicate(format: "repetition >= %i",1)
        
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [exerciseSort, repetitionSort, endDateSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: #keyPath(Walk.exerciseID), cacheName: "worldCup")
        
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }

    @IBAction func assignmentsButtonTapped(_ sender: UIButton) {
        let assignmentsViewController = AssignmentsViewController.instantiate(fromAppStoryboard: .assignmentsViewController)
        assignmentsViewController.accessorID = "ebb1f78c-704d-40c5-a1bc-8b024e3956bc"
        assignmentsViewController.patientName = "Fido"
        assignmentsViewController.accessLevel = .patient
        self.present(assignmentsViewController, animated: true, completion: nil)
    }
}

extension ProgressGeneralViewController {
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? progressCell else {
            return
        }
        
        let progress = fetchedResultsController.object(at: indexPath)
        cell.targetPractice.text = "Repetition: \(progress.repetition)"
        let startDate = progress.startDate
        let endDate = progress.endDate
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.maximumUnitCount = 1
//        let interval = form5atter.string(from: startDate! as Date!, to: endDate as Date!)
        let interval = intervalCalculate(startDate: startDate!, endDate: endDate!)
        cell.duration.text = "Duration: \(interval)"
        
    }
}

extension ProgressGeneralViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }

        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: progressCellIdentifier, for: indexPath)
        configure(cell: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return exerciseInfo[(sectionInfo?.name)!]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let practiceResult = fetchedResultsController.object(at: indexPath)
        let startDate = practiceResult.startDate
        let endDate = practiceResult.endDate
        let interval = intervalCalculate(startDate: startDate!, endDate: endDate!)
        let progressDetailVC = ProgressDetailViewController.instantiate(fromAppStoryboard: .progressDetailViewController)
        progressDetailVC.exerciseID = exerciseInfo[(practiceResult.exerciseID)!]
        progressDetailVC.duration = interval
        progressDetailVC.avgAngle = practiceResult.avgAngle
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let duration = dateFormatter.string(from: practiceResult.startDate! as Date)
        print(duration)
        progressDetailVC.start = duration
        progressDetailVC.repetitions = practiceResult.repetition
        self.present(progressDetailVC, animated: true, completion: nil)
    }
}

extension ProgressGeneralViewController {
    @IBAction func backToMain(_ sender: Any) {
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




