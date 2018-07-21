//
//  PeakFinding.swift
//  M2M
//
//  Created by Tran Sam on 7/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class PeakFinding {
    
    var leftSide: Float = 0
    var rightSide: Float = 0
    
    var leftTime: Float = 0
    var sign: Float = 1
    
    var started: Bool = false
    var ended: Bool = true
    
    var currentValue: Float = 0
    var currentTime : Float = 0
    var currentDiffValue: Float = 0
    
    var startingValue: Float = 0
    
    init () {}
    
    func add(value: Float, time: Float) {
        currentValue = value
        currentTime = time
    }
    
    func diffData(sideValue: Float) {
        currentDiffValue = currentValue - sideValue
    }
    
    func check() -> (Float, Float, Float, Float) {
        var returnValue: Float = 0
        var returnTime: Float = 0
        var returnSign: Float = 0
        var returnDiff: Float = 0
        
        if (started) && (!ended){
            diffData(sideValue: leftSide)
            if currentDiffValue != 0 {
                let currentSign = currentDiffValue/abs(currentDiffValue)
                if currentSign == sign {
                    leftSide = currentValue
                    leftTime = currentTime
                } else if currentSign == sign * (-1) {
                    rightSide = currentValue
                    started = false
                    ended = true
                    returnValue = leftSide
                    returnTime = leftTime
                    returnSign = sign
                    returnDiff = abs(currentValue - startingValue)
                }
            }
        } else if (ended) {
            diffData(sideValue: rightSide)
            if currentDiffValue != 0 {
                sign = currentDiffValue/abs(currentDiffValue)
                started = true
                ended = false
                leftSide = currentValue
                startingValue = currentValue
            }
        }
        
        return (returnValue, returnTime, returnSign, returnDiff)
    }
}
