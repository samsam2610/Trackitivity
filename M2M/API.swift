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
    var tempData = [Patient]()
    func getPatients(completion:  @escaping ([Patient]) -> ()){
        
        let url = URL(string: stringURL!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        let patientData = try JSONDecoder().decode([Patient].self, from: urlContent)
                        completion(patientData)
    
                    } catch {
                        print("Json Processing Failed")
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
}
