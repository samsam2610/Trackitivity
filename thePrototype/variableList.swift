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
var First: Int = 0, Second: Int = 0, dBefore: Int = 0, dAfter: Int = 0, Max: Int = 0, Min: Int = 0, currentMax: Int = 0, currentMin: Int = 0, sessionMax: Int = 0, sessionMin: Int = 0
var currentCount: Double = 0 // Number of actual repetition
var targetCount: Double = 20 // Expected number of repetition
var totalTime: TimeInterval = 0 
var targetTime: Double = 60
var avgROM: Int = 0 // Average Range of Motion
var startTime: NSCalendar?
var endTime: NSCalendar?

var thighMaxAngle: Int?
var thighMinAngle: Int?

let exercise = ["Sitting Unsupported Knee Bends", "Standing Knee Bends"]
let descrip = ["While sitting at your bedside or in a chair with your thigh supported, place your foot behind the heel of your operated knee for support. Slowly bend your knee as far as you can. Hold your knee in this position for 5 to 10 seconds.","Standing erect with the aid of a walker or crutches, lift your thigh and bend your knee as much as you can. Hold for 5 to 10 seconds. Then straighten your knee, touching the floor with your heel first."]


var selectedExercise = exercise[0]
