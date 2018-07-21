//
//  GaitEvent.swift
//  M2M
//
//  Created by Tran Sam on 7/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class GaitEvent {
    var gyro: [Float]
    var dataGyro: [Float] = []
    var thresholdGyro: Float
    
    var accel: [Float]
    var dataAccel: [Float] = []
    var thresholdAccel: Float
    
    var time: [Float]
    
    var quadriceps: [Float]
    var dataQuadriceps: [Float] = []
    var thresholdQuadriceps: Float
    
    var hamstring: [Float]
    var dataHamstring: [Float] = []
    var thresholdHamstring: Float
    
    var peakGyro = PeakFinding()
    var peakAccel = PeakFinding()
    var peakHamstring = PeakFinding()
    var peakQuadriceps = PeakFinding()
    
    var contractHamstring: Threshold
    var contractQuadriceps: Threshold
    
    var outputGyro: String = "None"
    var outputAccel: String = "None"
    
    var outputPeakHamstring: String = "None"
    var outputContractHamstring: String = "None"
    var outputPeakQuadriceps: String = "None"
    var outputContractQuadriceps: String = "None"

    
    var dataEvent: [[Any]] = []
    
    init(maxSize: Int, specialValue: Float,
         thresholdGyro: Float, thresholdAccel: Float,
         thresholdHamstring: Float, thresholdQuadriceps: Float,
         contractThresholdHamstring: Float,
         contractThresholdQuadriceps: Float) {
        
        (gyro, accel, time) = emptyXYZQueue(maxSize: maxSize, value: specialValue)
        (hamstring, quadriceps, _) = emptyXYZQueue(maxSize: maxSize, value: specialValue)
        
        self.thresholdGyro = thresholdGyro
        self.thresholdAccel = thresholdAccel
        self.thresholdHamstring = thresholdHamstring
        self.thresholdQuadriceps = thresholdQuadriceps
        
        contractHamstring = Threshold(thresholdValue: contractThresholdHamstring)
        contractQuadriceps = Threshold(thresholdValue: contractThresholdQuadriceps)
    }
        
    func currentIMU(IMU: IMU) {
        gyro = IMU.sensitiveGyro
        accel = IMU.sensitiveAccel
    }
    
    func currentEMG(EMG: EMG) {
        hamstring = EMG.filteredHamstring
        quadriceps = EMG.filteredQuadriceps
    }
    
    func analyzeGyro() {
        
        outputGyro = "None"
        
        peakGyro.add(value: gyro.last!, time: time.last!)
        let localValue: Float
        let localTime: Float
        let localSign: Float
        let localDiff: Float
        (localValue, localTime, localSign, localDiff) = peakGyro.check()
        outputGyro = peakFilter(localValue, localTime, localSign, localDiff,
                                eventLabel: "Gyro 1",
                                localThresholdDiff: 1, localThresholdSign: -1,
                                localThresholdValue: abs(thresholdGyro))
        
        guard outputGyro == "None" else { return }
        
        outputGyro = peakFilter(localValue, localTime, localSign, localDiff,
                                eventLabel: "Gyro 3",
                                localThresholdDiff: 4, localThresholdSign: -1,
                                localThresholdValue: abs(thresholdGyro))
        
        guard outputGyro == "None" else { return }
        
        outputGyro = peakFilter(localValue, localTime, localSign, localDiff,
                                eventLabel: "Gyro 2",
                                localThresholdDiff: 4, localThresholdSign: -1,
                                localThresholdValue: abs(thresholdGyro))
    }
    
    func analyzeAccel() {
        outputAccel = "None"
        
        peakAccel.add(value: accel.last!, time: time.last!)
        let localValue: Float
        let localTime: Float
        let localSign: Float
        let localDiff: Float
        (localValue, localTime, localSign, localDiff) = peakAccel.check()
        outputAccel = peakFilter(localValue, localTime, localSign, localDiff,
                                eventLabel: "Accel 1",
                                localThresholdDiff: 0, localThresholdSign: 1,
                                localThresholdValue: abs(thresholdAccel))
        
    }
    
    func analyzeHamstring() {
        outputPeakHamstring = "None"
        outputContractHamstring = "None"
        
        peakHamstring.add(value: hamstring.last!, time: time.last!)
        let localValue: Float
        let localTime: Float
        let localSign: Float
        let localDiff: Float
        (localValue, localTime, localSign, localDiff) = peakHamstring.check()
        outputPeakHamstring = peakFilter(localValue, localTime, localSign, localDiff,
                                 eventLabel: "Hamstring",
                                 localThresholdDiff: 0.2, localThresholdSign: 1,
                                 localThresholdValue: thresholdHamstring)
        
        contractHamstring.add(value: hamstring.last!, time: time.last!)
        let contractStart: Float
        let contractEnd: Float
        (_ , contractStart, contractEnd) = contractHamstring.check()
        outputContractHamstring = thresholdFilter(eventStart: contractStart, eventEnd: contractEnd, eventLabel: "Hamstring")
        
    }
    
    func analyzeQuadriceps() {
        outputPeakQuadriceps = "None"
        outputContractQuadriceps = "None"
        
        peakQuadriceps.add(value: quadriceps.last!, time: time.last!)
        let localValue: Float
        let localTime: Float
        let localSign: Float
        let localDiff: Float
        (localValue, localTime, localSign, localDiff) = peakQuadriceps.check()
        outputPeakQuadriceps = peakFilter(localValue, localTime, localSign, localDiff,
                                         eventLabel: "Quadriceps",
                                         localThresholdDiff: 0.2, localThresholdSign: 1,
                                         localThresholdValue: thresholdQuadriceps)
        
        contractQuadriceps.add(value: quadriceps.last!, time: time.last!)
        let contractStart: Float
        let contractEnd: Float
        (_ , contractStart, contractEnd) = contractHamstring.check()
        outputContractQuadriceps = thresholdFilter(eventStart: contractStart, eventEnd: contractEnd, eventLabel: "Quadriceps")
        
    }

    
}
