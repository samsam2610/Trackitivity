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
    private var exerciseDict: [String : ExerciseData]?
    private var exercises: [ExerciseData]?

    func retriveExercise(_ exerciseID: String) -> ExerciseData? {
        let completion = { (returnedExercises: [ExerciseData]) in
            self.exercises = returnedExercises

            for exercise in returnedExercises {
                self.exerciseDict![exercise.id!] = exercise
            }
        }

        if exercises?.count == 0 {
            ExerciseAPIHelper.manager.getExercises(AuthData.auth.getUserID()!, completionHandler: completion, errorHandler: { print($0) })
        }

        return exerciseDict?[exerciseID]
    }

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
