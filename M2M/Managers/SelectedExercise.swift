//
//  SelectedExercise
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
    private var exerciseDict = [String : ExerciseData]()
    private var exercises = [ExerciseData]()

    func populateExercises() {
        let completion = { (returnedExercises: [ExerciseData]) in
            DispatchQueue.main.async {
                self.exercises = returnedExercises

                for exercise in returnedExercises {
                    self.exerciseDict[exercise.id!] = exercise
                }
            }
        }

        ExerciseAPIHelper.manager.getExercises(AuthData.auth.getUserID()!, completionHandler: completion, errorHandler: { print($0) })
    }

    func retriveExercise(_ exerciseID: String) -> ExerciseData? {
        if exercises.count == 0 {
            populateExercises()
        }

        return exerciseDict[exerciseID]
    }

    func retrieveExerciseList() -> [ExerciseData] {
        return exercises
    }

    func chooseExercise(_ exercise: ExerciseData) {
        currentSelection = exercise
    }

    func chooseExerciseByAssignment(_ exerciseID: String) -> Bool {
        if let exercise = exerciseDict[exerciseID] {
            currentSelection = exercise
            return true
        }

        return false
    }

    func getSelectedExercise() -> ExerciseData? {
        if let currentSelection = currentSelection {
            return currentSelection
        }

        return nil
    }
}
