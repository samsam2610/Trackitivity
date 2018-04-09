//
//  ExerciseSelected.swift
//  M2M
//
//  Created by Victor Zhong on 4/9/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class SelectedExercise {
    private init() {}
    static let manager = SelectedExercise()

    private var currentSelection: ExerciseData?

    func chooseExercise(_ exercise: ExerciseData) {
        currentSelection = exercise
    }

    func getSelectedExercise() -> ExerciseData? {
        if let currentSelection = currentSelection {
            return currentSelection
        }
        return nil
    }
}
