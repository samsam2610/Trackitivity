//
//  EMG.swift
//  M2M
//
//  Created by Tran Sam on 7/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class EMG {
    var maxSize: Int
    
    var queueHamstring: [Float]
    var filteredHamstring: [Float]
    var currentMaxHamstring: Float = 0
    
    var queueQuadriceps: [Float]
    var filteredQuadriceps: [Float]
    var currentMaxQuadriceps: Float = 0
    
    var time: [Float]
    
    init(maxSize: Int, specialValue: Float) {
        self.maxSize = maxSize
        (queueHamstring, queueQuadriceps, time) = emptyXYZQueue(maxSize: maxSize, value: specialValue)
        (filteredHamstring, filteredQuadriceps, _) = emptyXYZQueue(maxSize: maxSize, value: specialValue)
    }
    
    func delete() {
        queueHamstring.removeFirst()
        queueQuadriceps.removeFirst()
        time.removeFirst()
    }
    
    func add(data: [Float], _ time: Float) {
        guard data.count == 2 else { return }
        self.delete()
        queueHamstring.append(data[0])
        queueQuadriceps.append(data[0])
        self.time.append(time)
    }
    
    func checkHamstringMax () {
        guard queueHamstring.max() != nil else { return }
        if queueHamstring.max()! > currentMaxHamstring {
            currentMaxHamstring = queueHamstring.max()!
        }
    }
    
    func normalizeHamstring () {
        guard currentMaxHamstring != 0 else { return }
        queueHamstring = queueHamstring.map { $0/currentMaxHamstring }
    }
    
    func filterHamstring() {
        self.checkHamstringMax()
        self.normalizeHamstring()
        filteredHamstring = queueHamstring
    }
    
    func checkQuadricepsMax () {
        guard queueQuadriceps.max() != nil else { return }
        if queueQuadriceps.max()! > currentMaxQuadriceps {
            currentMaxQuadriceps = queueQuadriceps.max()!
        }
    }
    
    func normalizeQuadriceps () {
        guard currentMaxQuadriceps != 0 else { return }
        queueQuadriceps = queueQuadriceps.map { $0/currentMaxQuadriceps }
    }
    
    func filterQuadriceps() {
        self.checkQuadricepsMax()
        self.normalizeQuadriceps()
        filteredQuadriceps = queueQuadriceps
    }
    
    func resetMax () {
        currentMaxQuadriceps = 0
        currentMaxHamstring = 0
    }
}
