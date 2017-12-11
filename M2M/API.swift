//
//  API.swift
//  M2M
//
//  Created by Tran Sam on 12/10/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import Foundation


class RestApiManager {
    
    var stringURL: String?
    
    func getPatients() {
        
        let url = URL(string: stringURL!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print(jsonResult)
                    } catch {
                        print("Json Processing Failed")
                    }
                }
            }
        }
        task.resume()
    }
    
    
}
