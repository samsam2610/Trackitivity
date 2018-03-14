//
//  activity.swift
//  M2M
//
//  Created by Tran Sam on 2/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

protocol activityParam: exerciseInfo {
    var timeStart: String {get set}
    var timeEnd: String {get set}
    var duration: String {get set}
    var repetitions: Int {get set}
    var averageAngle: Float {get set}
    var minAngle: Float {get set}
    var maxAngle: Float {get set}
}
