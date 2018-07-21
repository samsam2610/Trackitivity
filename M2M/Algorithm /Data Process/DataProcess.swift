//
//  DataProcess.swift
//  M2M
//
//  Created by Tran Sam on 7/21/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class DataProcess {
    
    private init () {}
    static let manager = DataProcess()
    
    var queueIMU = IMU(order: 1, maxSize: 50, specialValue: 0)
    var queueEMG = EMG(maxSize: 50, specialValue: 0)
    var gaitEvent = GaitEvent(maxSize: 50, specialValue: 0, thresholdGyro: -0.5, thresholdAccel: -6.5, thresholdHamstring: 0.4, thresholdQuadriceps: 0.4, contractThresholdHamstring: 0.45, contractThresholdQuadriceps: 0.45)
    
    func add(dataIMU: [Float], dataEMG: [Float], time: Float) {
        queueIMU.add(data: dataIMU, time)
        queueEMG.add(data: dataEMG, time)
        
        queueIMU.filterAccel()
        queueIMU.filterGyro()
        queueEMG.filterHamstring()
        queueEMG.filterQuadriceps()
        
        queueIMU.getGyro()
        queueIMU.getAccel()
        
        gaitEvent.currentIMU(IMU: queueIMU)
        gaitEvent.currentEMG(EMG: queueEMG)
        
        gaitEvent.analyzeGyro()
        gaitEvent.analyzeAccel()
        gaitEvent.analyzeHamstring()
        gaitEvent.analyzeQuadriceps()
    }
    
    
    func getGyro() -> String {
        return gaitEvent.outputGyro
    }
    
    func getAccel() -> String {
        return gaitEvent.outputAccel
    }
    
    func getHamstring() -> (String, String) {
        return (gaitEvent.outputPeakHamstring, gaitEvent.outputContractHamstring)
    }
    
    func getQuadriceps() -> (String, String) {
        return (gaitEvent.outputPeakQuadriceps, gaitEvent.outputContractQuadriceps)
    }
    
}
