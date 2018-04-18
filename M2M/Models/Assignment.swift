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
    var scores: Int?
    var scoredDate: String?
    var therapistComment: String
    var thresholdROM: Int
    var expectedDuration: Int
    var expectedRepetitions: Int
    var duration: Int?
    var creatorID: String
    var patientID: String
    var creator: TherapistCredential?
    var patient: PatientCredential?
    var activities: [Activity]
    var timeCreated: String
    var timeModified: String
    var exerciseID: String
    var exercise: ExerciseData

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
        case timeCreated = "time_created"
        case timeModified = "time_modified"
        case exerciseID = "exercise_id"
        case exercise
    }

    // MARK: - Init
    init(
        id: String,
        scores: Int?,
        scoredDate: String?,
        therapistComment: String,
        thresholdROM: Int,
        expectedDuration: Int,
        expectedRepetitions: Int,
        duration: Int?,
        creatorID: String,
        patientID: String,
        creator: TherapistCredential?,
        patient: PatientCredential?,
        activities: [Activity],
        timeCreated: String,
        timeModified: String,
        exerciseID: String,
        exercise: ExerciseData
        ) {
        self.id = id
        self.scores = scores
        self.scoredDate = scoredDate
        self.therapistComment = therapistComment
        self.thresholdROM = thresholdROM
        self.expectedDuration = expectedDuration
        self.expectedRepetitions = expectedRepetitions
        self.duration = duration
        self.creatorID = creatorID
        self.patientID = patientID
        self.creator = creator
        self.patient = patient
        self.activities = activities
        self.timeCreated = timeCreated
        self.timeModified = timeModified
        self.exerciseID = exerciseID
        self.exercise = exercise
    }

    // MARK: - Init from Decoder
    init(from decoder: Decoder) throws {
        let container =  try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.scores = try container.decode(Int?.self, forKey: .scores)
        self.scoredDate = try container.decode(String?.self, forKey: .scoredDate)
        self.therapistComment = try container.decode(String.self, forKey: .therapistComment)
        self.thresholdROM = try container.decode(Int.self, forKey: .thresholdROM)
        self.expectedRepetitions = try container.decode(Int.self, forKey: .expectedRepetitions)
        self.creatorID = try container.decode(String.self, forKey: .creatorID)
        self.patientID = try container.decode(String.self, forKey: .patientID)
        self.creator = try container.decode(TherapistCredential?.self, forKey: .creator)
        self.patient = try container.decode(PatientCredential?.self, forKey: .patient)
        self.activities = try container.decode([Activity].self, forKey: .activities)
        self.timeCreated = try container.decode(String.self, forKey: .timeCreated)
        self.timeModified = try container.decode(String.self, forKey: .timeModified)
        self.exerciseID = try container.decode(String.self, forKey: .exerciseID)
        self.exercise = try container.decode(ExerciseData.self, forKey: .exercise)

        do {
            self.expectedDuration = try container.decode(Int.self, forKey: .expectedDuration)
        } catch DecodingError.typeMismatch {
            let value = try container.decode(String.self, forKey: .expectedDuration)
            self.expectedDuration = Int(value) ?? 0
        }

        do {
            self.duration = try container.decode(Int?.self, forKey: .duration)
        } catch DecodingError.typeMismatch {
            let value = try container.decode(String?.self, forKey: .duration)
            if let val = value {
                self.duration = Int(val) ?? 0
            } else {
                self.duration = 0
            }
        }
    }
}


struct AssignmentPost: Codable {
    var therapistComment: String
    var thresholdROM: Int
    var expectedRepetitions: Int
    var expectedDuration: Int
    var exeriseID: String
    var exercise: ExerciseData
    var creatorID: String
    var patientID: String

    private enum CodingKeys: String, CodingKey {
        case therapistComment = "therapist_comment"
        case thresholdROM = "threshold_ROM"
        case expectedRepetitions = "expected_repetitions"
        case expectedDuration = "expected_duration"
        case exeriseID = "exercise_id"
        case exercise = "exercise"
        case creatorID = "creator_id"
        case patientID = "patient_id"
    }

    init(exercise: ExerciseData,
         creatorID: String,
         patientID: String) {
        self.therapistComment = exercise.exerciseName
        self.thresholdROM = Int(exercise.thighAngle_max)
        self.expectedRepetitions = 10
        self.expectedDuration = 123
        self.exeriseID = exercise.id!
        self.creatorID = creatorID
        self.patientID = patientID
        self.exercise = exercise
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

