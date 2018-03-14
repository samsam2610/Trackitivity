//
//  FetchDataManager.swift
//  M2M
//
//  Created by Tran Sam on 2/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation
import CoreData

class FetchedDataManager {
    var fetchedResultsController: NSFetchedResultsController<Walk>!
    var managedContext: NSManagedObjectContext!
    var numberOfObjects: Int?
    init(_ a: NSManagedObjectContext) {
        self.managedContext = a
        self.initializeFetchedResultsController()
        let sections = fetchedResultsController.sections
        numberOfObjects = sections?.count
        print(numberOfObjects!)
    }
    
    func initializeFetchedResultsController() {
        
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        
        let exerciseSort = NSSortDescriptor(key: #keyPath(Walk.exerciseID), ascending: true)
        let repetitionSort = NSSortDescriptor(key: #keyPath(Walk.repetition), ascending: false)
        let endDateSort = NSSortDescriptor(key: #keyPath(Walk.endDate), ascending: true)
        
        fetchRequest.sortDescriptors = [exerciseSort, repetitionSort, endDateSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                              managedObjectContext: managedContext, sectionNameKeyPath:#keyPath(Walk.exerciseID),
                                                              cacheName: "worldCup")
        
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    func summaryOfData() {
    }
}

