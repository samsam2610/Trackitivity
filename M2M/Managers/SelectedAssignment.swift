//
//  SelectedAssignment.swift
//  M2M
//
//  Created by Victor Zhong on 4/18/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class SelectedAssignment {
    private init() {}
    static let manager = SelectedAssignment()

    private var currentSelection: String?
    private var exerciseDict = [String : ExerciseData]()
    private var exercises = [ExerciseData]()


}
