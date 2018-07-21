//
//  Threshold.swift
//  M2M
//
//  Created by Tran Sam on 7/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class Threshold {
    var thresholdValue: Float
    var startingTime: Float = 0
    
    var currentValue: Float = 0
    var currentTime: Float = 0
    var currentDuration: Float = 0
    
    var started: Bool = false
    var ended: Bool = true
    
    init(thresholdValue: Float) {
        self.thresholdValue = thresholdValue
    }
    
    func add(value: Float, time: Float) {
        currentValue = value
        currentTime = time
    }
    
    func setThreshold(thresholdValue: Float) {
        self.thresholdValue = thresholdValue
    }
    
    func check() -> (Float, Float, Float) {
        var returnDuration: Float = 0
        var returnEnding: Float = 0
        var returnStarting: Float = 0
        
        if currentValue > thresholdValue
            && (!started)
            && (ended) {
            startingTime = currentTime
            started = true
            ended = false
        } else if currentValue > thresholdValue
            && (started)
            && (!ended) {
            currentDuration = currentTime - startingTime
        } else if currentValue < thresholdValue
            && (started)
            && (!ended) {
            currentDuration = currentTime - startingTime
            started = false
            ended = true
            returnStarting = startingTime
            returnEnding = currentTime
            returnDuration = currentDuration
        }
        
        return (returnDuration, returnStarting, returnEnding)
    }
}
