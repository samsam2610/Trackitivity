//
//  IMU.swift
//  M2M
//
//  Created by Tran Sam on 7/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class IMU {
    var order: Int
    var maxSize: Int
    var queueGx: [Float]
    var queueGy: [Float]
    var queueGz: [Float]
    
    var queueAx: [Float]
    var queueAy: [Float]
    var queueAz: [Float]
    
    var filteredGx: [Float]
    var filteredGy: [Float]
    var filteredGz: [Float]
    
    var filteredAx: [Float]
    var filteredAy: [Float]
    var filteredAz: [Float]
    
    var sensitiveGyro: [Float]
    var sensitiveAccel: [Float]
    var time: [Float]
    
    var specialValue: Float
    
    init(order: Int, maxSize: Int, specialValue: Float) {
        self.order = order
        self.maxSize = maxSize
        self.specialValue = specialValue
        (queueGx, queueGy, queueGz) = emptyXYZQueue(maxSize: maxSize, value: specialValue)
        (filteredGx, filteredGy, filteredGz) = emptyXYZQueue(maxSize: maxSize, value: specialValue)
        
        (queueAx, queueAy, queueAz) = emptyXYZQueue(maxSize: maxSize, value: specialValue)
        (filteredAx, filteredAy, filteredAz) = emptyXYZQueue(maxSize: maxSize, value: specialValue)

        (sensitiveGyro, sensitiveAccel, time) = emptyXYZQueue(maxSize: maxSize, value: specialValue)

    }
    
    func delete() {
        queueGx.removeFirst()
        queueGy.removeFirst()
        queueGz.removeFirst()
        queueAx.removeFirst()
        queueAy.removeFirst()
        queueAz.removeFirst()
        time.removeFirst()
    }
    
    func add(data: [Float], _ time: Float) {
        guard data.count == 6 else { return }
        
        self.delete()
        queueGx.append(data[0 + order])
        queueGy.append(data[1 + order])
        queueGz.append(data[2 + order])
        queueAx.append(data[3 + order])
        queueAy.append(data[4 + order])
        queueAz.append(data[5 + order])
        self.time.append(time)
    }
    
    func filterGyro() {
        filteredGx = queueGx
        filteredGy = queueGy
        filteredGz = queueGz
    }
    
    func filterAccel() {
        filteredAx = queueAx
        filteredAy = queueAy
        filteredAz = queueAz
    }
    
    func getGyro() {
        sensitiveGyro = getSensitiveAxis(dataX: filteredGx, dataY: filteredGy, dataZ: filteredGz)
    }
    
    func getAccel() {
        sensitiveAccel = getSensitiveAxis(dataX: filteredAx, dataY: filteredAy, dataZ: filteredAz)
    }
    
    func sensitiveTest(data: [Float]) -> (Float) {
        let output = data.reduce(0, {x, y in
            abs(x) + abs(y)
        })
        return output
    }
    
    func getSensitiveAxis(dataX: [Float], dataY: [Float], dataZ: [Float]) -> ([Float]) {
        var sensitiveAxis = [Float](repeating: 0, count: maxSize)
        let maxX = sensitiveTest(data: dataX)
        let maxY = sensitiveTest(data: dataY)
        let maxZ = sensitiveTest(data: dataZ)
        
        if maxX > maxY && maxX > maxZ {
            sensitiveAxis = dataX
        } else if maxY > maxX && maxY > maxZ {
            sensitiveAxis = dataY
        } else if maxZ > maxX && maxZ > maxY {
            sensitiveAxis = dataZ
        }
        
        return sensitiveAxis
    }
}
