//
//  filters.swift
//  M2M
//
//  Created by Tran Sam on 7/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

func peakFilter (_ localValue: Float, _ localTime: Float, _ localSign: Float, _ localDiff: Float,
                 eventLabel: String,
                 localThresholdDiff: Float, localThresholdSign: Float, localThresholdValue: Float) -> (String) {
    
    var outputString: String = "None"
    
    if localTime > 0 &&
        localSign == localThresholdSign &&
        abs(localDiff) > localThresholdDiff &&
        abs(localValue) > localThresholdValue {
        
        outputString = eventLabel
    }
    
    return outputString
}

func thresholdFilter (eventStart: Float, eventEnd: Float,
                      eventLabel: String) -> (String) {
    var outputString: String = "None"
    
    if eventStart > 0 &&
        eventEnd == 0 {
        outputString = "Start " + eventLabel
    } else if eventEnd > 0 {
        outputString = "End " + eventLabel
    }
    
    return outputString
}

