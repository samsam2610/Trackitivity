//
//  File.swift
//  thePrototype
//
//  Created by Tran Sam on 9/25/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreData


var txCharacteristic : CBCharacteristic?
var rxCharacteristic : CBCharacteristic?
var blePeripheral : CBPeripheral?
var characteristicASCIIValue = NSString()
var people: [NSManagedObject] = []
var rawData: [String] = []
var stringData = String()
var clearedStringData = String()
var connected: Bool = false

var workoutActive = false
var First: Double = 0, Second: Double = 0, dBefore: Double = 0, dAfter: Double = 0, Max: Double = 0, Min: Double = 0, currentMax: Double = 0, currentMin: Double = 0, sessionMax: Double = 0, sessionMin: Double = 0
var currentCount: Double = 0 // Number of actual repetition
var targetCount: Double = 50 // Expected number of repetition
var totalTime: TimeInterval = 0 
var targetTime: Double = 120
var targetROM: Double = 50
var avgROM: Double = 0 // Average Range of Motion
var startTime: NSCalendar?
var endTime: NSCalendar?
var currentROM: Double = 100

var thighMaxAngle: Double?
var thighMinAngle: Double?
var thighAngle: Double = 361

let exercise = ["Sitting Supported Knee Bends","Standing Knee Bends"]
let exerciseID = ["SSKB","SKB"]
let descrip = ["While sitting at your bedside or in a chair with your thigh supported, place your foot behind the heel of your operated knee for support. Slowly bend your knee as far as you can. Hold your knee in this position for 5 to 10 seconds.","Standing erect with the aid of a walker or crutches, lift your thigh and bend your knee as much as you can. Hold for 5 to 10 seconds. Then straighten your knee, touching the floor with your heel first."]



var selectedExercise = exercise[0]
var selectedExerciseID = exerciseID[0]



let practiceVC = PracticeViewController.instantiate(fromAppStoryboard: .practiceViewController)
let mainVC = MainViewController.instantiate(fromAppStoryboard: .mainViewController)
let bleVC = bleViewController.instantiate(fromAppStoryboard: .bleViewController)
let progressVC = ProgressViewController.instantiate(fromAppStoryboard: .progressViewController)
let progressDetailVC = ProgressDetailViewController.instantiate(fromAppStoryboard: .progressDetailViewController)
let exerciseVC = ExerciseViewController.instantiate(fromAppStoryboard: .exerciseViewController)
let doctorVC = DoctorViewController.instantiate(fromAppStoryboard: .doctorViewController)
let doctorProgressVC = DoctorProgressViewController.instantiate(fromAppStoryboard: .doctorProgressViewController)
let progressGeneralVC = ProgressGeneralViewController.instantiate(fromAppStoryboard: .progressGeneralViewController)
let exerciseParameterVC = ExerciseParameterViewController.instantiate(fromAppStoryboard: .exerciseParameterViewController)







