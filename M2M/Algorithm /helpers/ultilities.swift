//
//  ultilities.swift
//  M2M
//
//  Created by Tran Sam on 7/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

func emptyXYZQueue(maxSize: Int, value: Float) -> ([Float], [Float], [Float]) {
    let dataX = [Float](repeating: value, count: maxSize)
    let dataY = [Float](repeating: value, count: maxSize)
    let dataZ = [Float](repeating: value, count: maxSize)
    
    return (dataX, dataY, dataZ)
}

