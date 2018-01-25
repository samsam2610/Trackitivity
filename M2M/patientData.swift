//
//  patientData.swift
//  M2M
//
//  Created by Tran Sam on 12/29/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import Foundation
import CoreData

protocol exerciseParam  {
    var timeStart: String {get set}
    var timeEnd: String {get set}
    var duration: String {get set}
    var repetitions: Int {get set}
    var averageAngle: Float {get set}
    var minAngle: Float {get set}
    var maxAngle: Float {get set}
}

protocol exerciseData: exerciseParam {
    var exerciseName: String {get}
}

struct PatientCredential: Codable {
    var email: String
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
    }
}

struct PatientData: exerciseData, Codable {
    
    var name: String
    var exerciseName: String
    var timeStart: String
    var timeEnd: String
    var duration: String
    var repetitions: Int
    var averageAngle: Float
    var minAngle: Float
    var maxAngle: Float
    
    private enum CodingKeys: String, CodingKey {
        case name = "user_id"
        case exerciseName = "title"
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case duration
        case repetitions
        case averageAngle = "average_angle"
        case minAngle = "min_angle"
        case maxAngle = "max_angle"
        
    }
    
    init(toJSon name: String, exerciseName: String, timeStart: Date, timeEnd: Date, repetitions: Int, averageAngle: Float, minAngle: Float, maxAngle: Float) {
        self.name = name
        self.exerciseName = exerciseName
        self.timeStart = String(Int(timeStart.timeIntervalSince1970))
        self.timeEnd = String(Int(timeEnd.timeIntervalSince1970))
        self.repetitions = repetitions
        self.averageAngle = averageAngle
        self.minAngle = minAngle
        self.maxAngle = maxAngle
        self.duration = ""
        duration = intervalCalculate(startDate: timeStart, endDate: timeEnd)
    }
    
    func intervalCalculate(startDate: Date, endDate: Date) -> String {
        
        let interval = String(Int(endDate.timeIntervalSince(startDate)))
        return interval
    }
}

struct LoginData: Codable {
    var userID: String
    var email: String
    
    private enum CodingKeys: String, CodingKey {
        case userID = "id"
        case email
    }
}

class authData {
    static let auth = authData()
    var loginData: LoginData?
}

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
