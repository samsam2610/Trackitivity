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

    func getExercises() {}

    func getOneExercise() {}

    func postExercise() {}

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
