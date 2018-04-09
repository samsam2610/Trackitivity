//
//  Activity.swift
//  M2M
//
//  Created by Tran Sam on 2/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

protocol ActivityParam: ExerciseInfo {
    var timeStart: String {get set}
    var timeEnd: String {get set}
    var duration: String {get set}
    var repetitions: Int {get set}
    var averageAngle: Float {get set}
    var minAngle: Float {get set}
    var maxAngle: Float {get set}
}

struct Activity: ActivityParam {
    var exerciseName: String
    var timeStart: String
    var timeEnd: String
    var duration: String
    var repetitions: Int
    var averageAngle: Float
    var minAngle: Float
    var maxAngle: Float
}
