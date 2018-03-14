//
//  exerciseData.swift
//  M2M
//
//  Created by Tran Sam on 2/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation



protocol exerciseInfo {
    var exerciseName: String {get}
}

protocol exerciseParam {
    var thighAngle_min: Int16 { get }
    var thighAngle_max: Int16 { get }
    var legAngle_min: Int16 { get }
    var legAngle_max: Int16 { get }
}

protocol exerciseInstruction {
    var description: String { get }
//    var link: URL { get }
}
