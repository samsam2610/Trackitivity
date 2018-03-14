//
//  ExerciseParameter.swift
//  M2M
//
//  Created by Tran Sam on 2/25/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ExerciseParameterViewModel {
    
    private let apiClient = APIClient()
    
    let thighAngle_max_Valid: Driver<Int16>
    let thighAngle_min_Valid: Driver<Int16>
    let legAngle_max_Valid: Driver<Int16>
    let legAngle_min_Valid: Driver<Int16>
    let dataValid: Driver<Bool>
    
    init(_ exerciseName: Driver<String>,
         _ thighAngle_max: Driver<String>,
         _ thighAngle_min: Driver<String>,
         _ legAngle_max: Driver<String>,
         _ legAngle_min: Driver<String>
        ) {
        
         thighAngle_max_Valid = thighAngle_max
            .distinctUntilChanged()
            .throttle(0.3)
            .filter { $0 != "" }
            .map { Int16($0)! }
         thighAngle_min_Valid = thighAngle_min
            .distinctUntilChanged()
            .throttle(0.3)
            .filter { $0 != "" }
            .map { Int16($0)! }
         legAngle_max_Valid = legAngle_max
            .distinctUntilChanged()
            .throttle(0.3)
            .filter { $0 != "" }
            .map { Int16($0)! }
         legAngle_min_Valid = legAngle_min
            .distinctUntilChanged()
            .throttle(0.3)
            .filter { $0 != "" }
            .map { Int16($0)! }

        dataValid = Driver.combineLatest(
            thighAngle_max_Valid,
            thighAngle_min_Valid,
            legAngle_max_Valid,
            legAngle_min_Valid
        ) {
            ($0 > $1) && ($2 > $3)
            }
            .distinctUntilChanged()
        
    }

}


