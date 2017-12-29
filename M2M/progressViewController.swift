//
//  progressViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 11/19/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit
import CoreData

class progressViewController: UIViewController {

    

    
    // MARK: - Properties
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var managedContext: NSManagedObjectContext!
    var window: UIWindow?
    var currentDog: Dog?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.managedContext
        
        let dogName = "Fido"
        let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
        dogFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Dog.name), dogName)

        do {
            let practiceResults = try managedContext.fetch(dogFetch)
            if practiceResults.count > 0 {
                // Fido found, use Fido
                currentDog = practiceResults.first
            } else {
                // Fido not found, create Fido
                currentDog = Dog(context: managedContext)
                currentDog?.name = dogName
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    
}

extension progressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let walks = currentDog?.walks else {
            return 1
        }
        
        return walks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let walk = currentDog?.walks?[indexPath.row] as? Walk,
            let walkDate = walk.endDate as Date? else {
                return cell
        }
        
        cell.textLabel?.text = dateFormatter.string(from: walkDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of Walks"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let walkToRemove = currentDog?.walks?[indexPath.row] as? Walk,
            editingStyle == .delete else {
                return
        }
        
        managedContext.delete(walkToRemove)
        
        do {
            try managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Saving error: \(error), description: \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let practiceResult = currentDog?.walks?[indexPath.row] as? Walk
        let progressDetailVC = progressDetailViewController.instantiate(fromAppStoryboard: .progressDetailViewController)
        progressDetailVC.practiceResult = practiceResult!
        self.present(progressDetailVC, animated: true, completion: nil)
        
    }
}
extension progressViewController {
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
