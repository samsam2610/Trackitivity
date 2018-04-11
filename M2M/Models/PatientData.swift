//
//  PatientData.swift
//  M2M
//
//  Created by Tran Sam on 12/29/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import Foundation

struct PatientCredential: Codable {
    var email: String
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
    }
}

struct PatientData: ActivityParam, Codable {
    
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
}

extension PatientData {
    func intervalCalculate(startDate: Date, endDate: Date) -> String {
        let interval = String(Int(endDate.timeIntervalSince(startDate)))
        return interval
    }
}

struct Patient: Codable {
    let name: String
    let stage: Bool
    let id: Int
}


