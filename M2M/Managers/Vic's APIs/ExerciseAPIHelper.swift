//
//  ExerciseAPIHelper.swift
//  M2M
//
//  Created by Victor Zhong on 4/5/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class ExerciseAPIHelper {
    private init() {}
    static let manager = ExerciseAPIHelper()

    func getExercises(_ user: String, completionHandler: @escaping ([ExerciseData]) -> Void, errorHandler: @escaping (AppError) -> Void) {

        //REF: https://apiserver269.herokuapp.com/exercises?conditions=%7B%22creator_id%22%3A%20%22060445354b%22%7D&offset=1&limit=1&sort=-time_modified%20

        guard let baseSnippet = "{\"creator_id\":\"\(user)\"}".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            errorHandler(.badURL(string: "Encoding this:" + user))
            return
        }

        let baseURL = "https://apiserver269.herokuapp.com/exercises?conditions=\(baseSnippet)&sort=-time_modified"

        guard let url = URL(string: baseURL) else {
            errorHandler(.badURL(string: baseURL))
            return
        }

        print(url)

        let completion = { (data: Data) in
            do {
                let exercises = try JSONDecoder().decode([ExerciseData].self, from: data)

                completionHandler(exercises)
            } catch let error {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }

        // Use our helper to perform this task
        NetworkHelper.manager.performDataTask (
            with: url,
            completionHandler: completion,
            errorHandler: errorHandler)
    }

    func getOneExercise(_ id: String, completionHandler: @escaping (ExerciseData) -> Void, errorHandler: @escaping (AppError) -> Void) {

        let baseURL = "https://apiserver269.herokuapp.com/exercise/\(id)"

        guard let url = URL(string: baseURL) else {
            errorHandler(AppError.badURL(string: baseURL))
            return
        }

        let completion = { (data: Data) in
            do {
                let exercise = try JSONDecoder().decode(ExerciseData.self, from: data)

                completionHandler(exercise)
            } catch let error {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }

        // Use our helper to perform this task
        NetworkHelper.manager.performDataTask (
            with: url,
            completionHandler: completion,
            errorHandler: errorHandler)
    }

    func postExercise(_ exercise: ExerciseData, id: String?, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (AppError) -> Void) {

        var urlString = "https://apiserver269.herokuapp.com/exercise/"

        if let id = id {
            urlString += id
        }

        guard let url = URL(string: urlString) else {
            errorHandler(.badURL(string: urlString))
            return
        }

        var request = URLRequest(url: url)
        if let _ = id {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "POST"
        }

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonBody: [String : Any] = [
            "title": exercise.exerciseName,
            "thigh_angle_min": exercise.thighAngle_min,
            "thigh_angle_max": exercise.thighAngle_max,
            "leg_angle_min": exercise.legAngle_min,
            "leg_angle_max": exercise.legAngle_max,
            "description": exercise.description ?? "Perform the exercise as instructed by your therapist.",
//            "instructions": [
//                "text": exercise.instructions?.description ?? "",
//                "link": exercise.instructions?.link ?? ""
//                ] as [String : Any],
            "creator_id": AuthData.auth.getUserID()!
        ]

        do {
            //            let encodedExercise = try JSONEncoder().encode(jsonBody)
            let encodedExercise = try JSONSerialization.data(withJSONObject: jsonBody, options: [])

            request.httpBody = encodedExercise

            NetworkHelper.manager.performDataTask(with: request, completionHandler: completionHandler, errorHandler: errorHandler)
        } catch let error {
            errorHandler(.couldNotParseJSON(rawError: error))
        }

    }

    //MARK: - References
    /*
     //MARK: Body input
     {
     "title": "Leg Lifts (Light)",
     "description": "Take it easy and perform 3 sets of 10 reps.",
     "thigh_angle_min": 1,
     "thigh_angle_max": 123,
     "leg_angle_min": 1,
     "leg_angle_max": 123,
     "instructions": {
     "text": "From a 90 degree angle, lift your leg as much as you can, and then return back to starting position.",
     "link": ""
     },
     "creator_id": "d19c786f-633a-44ba-98ab-0d207592c4cc"
     }
     */

    /*
     //MARK: Server response
     {
     "id": "bfbd8c46-8d70-47f4-99e2-47d5082aa6bd",
     "title": "Leg Lifts (Light)",
     "description": "Take it easy and perform 3 sets of 10 reps.",
     "thigh_angle_min": 1,
     "thigh_angle_max": 123,
     "leg_angle_min": 1,
     "leg_angle_max": 123,
     "instructions": {
     "link": "",
     "text": "From a 90 degree angle, lift your leg as much as you can, and then return back to starting position."
     },
     "creator_id": "d19c786f-633a-44ba-98ab-0d207592c4cc",
     "time_created": "1522924957163",
     "time_modified": "1522924957163"
     }*/
}
