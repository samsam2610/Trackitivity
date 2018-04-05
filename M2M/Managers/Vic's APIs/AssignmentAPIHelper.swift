//
//  AssignmentAPIHelper.swift
//  M2M
//
//  Created by Victor Zhong on 3/21/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class AssignmentAPIHelper {
    private init() {}
    static let manager = AssignmentAPIHelper()

    // Get and parse assignments
    // ID: d19c786f-633a-44ba-98ab-0d207592c4cc
    func getAssignments(_ user: String, completionHandler: @escaping ([Assignment]) -> Void, errorHandler: @escaping (AppError) -> Void) {

        // REF: https://apiserver269.herokuapp.com/assignments?conditions=%7B%22user_id%22%3A%20%22060445354b%22%7D&offset=1&limit=1&sort=-time_modified%20

        guard let baseSnippet = "{\"patient_id\":\"\(user)\"}".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            errorHandler(.badURL(string: "Encoding this:" + user))
            return
        }

        let baseURL = "https://apiserver269.herokuapp.com/assignments?conditions=\(baseSnippet)&sort=-time_modified"

        guard let url = URL(string: baseURL) else {
            errorHandler(.badURL(string: baseURL))
            return
        }

        print(url)

        let completion = { (data: Data) in
            do {
                let assignments = try JSONDecoder().decode([Assignment].self, from: data)

                completionHandler(assignments)
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

    func getOneAssignment(_ id: String, completionHandler: @escaping (Assignment) -> Void, errorHandler: @escaping (AppError) -> Void) {

        let baseURL = "https://apiserver269.herokuapp.com/assignment/\(id)"

        guard let url = URL(string: baseURL) else {
            errorHandler(AppError.badURL(string: baseURL))
            return
        }

        let completion = { (data: Data) in
            do {
                let assignment = try JSONDecoder().decode(Assignment.self, from: data)

                completionHandler(assignment)
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

    func postAssignment(_ assignment: Assignment, id: String?, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (AppError) -> Void) {

        var urlString = "https://apiserver269.herokuapp.com/assignment/"

        if let id = id {
            urlString += id
        }

        guard let url = URL(string: urlString) else {
            errorHandler(.badURL(string: "https://apiserver269.herokuapp.com/assignment"))
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

        // Need to grab score from Practice View Controller
        let jsonBody: [String : Any] = [
            "scores" : assignment.scores,
            "scored_date" : assignment.scoredDate,
            "therapist_comment": assignment.therapistComment,
            "threshold_ROM": assignment.thresholdROM,
            "expected_duration": assignment.expectedDuration,
            "expected_repetitions": assignment.expectedRepetitions,
            "duration": assignment.duration,
            "creator_id": assignment.creatorID,
            "patient_id": assignment.patientID
        ]

        do {
//            let encodedAssignment = try JSONEncoder().encode(jsonBody)
            let encodedAssignment = try JSONSerialization.data(withJSONObject: jsonBody, options: [])

            request.httpBody = encodedAssignment

            NetworkHelper.manager.performDataTask(with: request, completionHandler: completionHandler, errorHandler: errorHandler)
        } catch let error {
            errorHandler(.couldNotParseJSON(rawError: error))
        }
    }
}

