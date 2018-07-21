
//  UartPackageManager.swift
//  M2M
//
//  Created by Tran Sam on 6/11/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

protocol UartPacketManagerDelegate: class {
    func onUartPacket(_ packet: UartPacket)
}

struct UartPacket {      // A packet of data received or sent
    var timestamp: CFAbsoluteTime
    var string: String
    init(timestamp: CFAbsoluteTime? = nil, string: String) {
        self.timestamp = timestamp ?? CFAbsoluteTimeGetCurrent()
        self.string = string
    }
}

class UartData {
    
    static let sharedInstance = UartData()
    private init() {}
    private var packets = [UartPacket]()
    
    
    func append(_ data: UartPacket) {
        packets.append(data)
    }
    
    func show() -> [UartPacket] {
        return packets
    }
}
