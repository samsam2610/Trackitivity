//
//  UartDataExport.swift
//  M2M
//
//  Created by Tran Sam on 6/11/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class UartDataExport {
        
    static func packetsAsCsv(_ packets: [UartPacket]) -> String? {
        var text = "Timestamp,Data\r\n"        // csv Header
        
        let timestampDateFormatter = DateFormatter()
        timestampDateFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss:SSS")
        
        for packet in packets {
            let date = Date(timeIntervalSinceReferenceDate: packet.timestamp)
            
            let dateString = timestampDateFormatter.string(from: date).replacingOccurrences(of: ",", with: ".")     //  comma messes with csv, so replace it by a point
            var dataString: String?
            dataString = packet.string
            
            // Remove newline characters from data (it messes with the csv format and Excel wont recognize it)
            dataString = dataString?.trimmingCharacters(in: CharacterSet.newlines) ?? ""
            text += "\(dateString),\"\(dataString!)\"\r\n"
        }
        return text
    }
}
