//
//  Assignment.swift
//  M2M
//
//  Created by Victor Zhong on 3/18/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

struct Assignment: Codable {
    var id: String
    var scores: String
    var scoredDate: String
    var therapistComment: String
    var thresholdROM: Int
    var expectedDuration: Int
    var expectedRepetitions: Int
    var duration: Int
    var creatorID: String
    var patientID: String
    var creator: Therapist
    var patient: Patient
    var activities: [String]

    private enum CodingKeys: String, CodingKey {
        case id
        case scores
        case scoredDate = "scored_date"
        case therapistComment = "therapist_comment"
        case thresholdROM = "threshold_ROM"
        case expectedDuration = "expected_duration"
        case expectedRepetitions = "expected_repetitions"
        case duration
        case creatorID = "creator_id"
        case patientID = "patient_id"
        case creator
        case patient
        case activities
    }

}


//{
//    "scores": "",
//    "scored_date": "",
//    "therapist_comment": "",
//    "threshold_ROM": 123,
//    "expected_duration": 123,
//    "expected_repetitions": 123,
//    "duration": "",
//    "creator_id": "",
//    "patient_id": ""
//}

//{
//    "id": "03d03028-bc74-46e5-8a91-d0060445354b",
//    "scores": "",
//    "scored_date": "",
//    "therapist_comment": "",
//    "threshold_ROM": 123,
//    "expected_duration": 123,
//    "expected_repetitions": 123,
//    "duration": "",
//    "creator_id": "",
//    "creator": {},
//    "patient_id": "",
//    "patient": {},
//    "activities": []
//}

