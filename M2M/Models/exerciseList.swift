//
//  exerciseList.swift
//  M2M
//
//  Created by Tran Sam on 2/23/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

// TODO: - Intended for use with API
let dummyData = exerciseData(toJson: "", 0, 0, 0, 0)

// Request list of exercises to be selected
class exerciseList_Get: APIRequest<exerciseData> {
    init(parameters: [String: String]){
        super.init(urlString: URLs.base!, method: RequestType.GET, path: URLpath.exercise.rawValue, parameters: parameters, data: dummyData)
    }
}


// Post new exercise to the list
class exerciseList_Add: APIRequest<exerciseData> {
    init(data: exerciseData) {
        super.init(urlString: URLs.base!, method: RequestType.POST, path: URLpath.exercise.rawValue, data: data)
    }
}
