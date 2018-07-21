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
    
    var queueQuadriceps: [Float]
    var filteredQuadriceps: [Float]
    
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
        queueHamstring.append(data[0])
        queueQuadriceps.append(data[0])
        self.time.append(time)
    }
    
    func filterHamstring() {
        filteredHamstring = queueHamstring
    }
    
    func filterQuadriceps() {
        filteredQuadriceps = queueQuadriceps
    }
}
