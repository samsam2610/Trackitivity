//
//  API.swift
//  M2M
//
//  Created by Tran Sam on 12/10/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import Foundation


struct RestApiManager {
    
    var stringURL: String?
    
    
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
    
    func getPatientData(completion:  @escaping ([PatientData]) -> ()){
        
        let url = URL(string: stringURL!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                if let urlContent = data {
                    
                    do {
                        print(urlContent)
                        let patientData = try JSONDecoder().decode([PatientData].self, from: urlContent)
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
    
    func postPatientActivity(parameters: PatientData, completion:((Error?) -> Void)?) {
                
        let url = URL(string: stringURL!)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(parameters)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion?(error!)
                return
            }
            // APIs usually respond with the data you just sent in your POST request
            if let data = data, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func Login(loginCredential: PatientCredential, completion:   @escaping (LoginData) -> ()) {
    
            guard let url = URL(string: stringURL!) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONEncoder().encode(loginCredential)
                // ... and set our request's HTTP body
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            } catch {
                print("encoding data failed")
                print(error)
            }
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("There is a response error")
                print(error!)
                return
            }
            // APIs usually respond with the data you just sent in your POST request
            if let data = data {
                do {
                    print(data)
                    let loginData = try JSONDecoder().decode(LoginData.self, from: data)
                    completion(loginData)
                    
                } catch {
                    print("Json Processing Failed")
                    print(error)
                }
                
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func createURLWithString(userID: String, userAction: String) -> NSURL? {
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = "apiserver269.herokuapp.com"
        components.path = userAction
        
        var query = "{\"user_id\":\"\(userID)\"}"
        query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        query = "conditions=" + query
        components.percentEncodedQuery = query
        
        let url = components.url
        return (url! as NSURL)
    }
}

enum UserAction: String {
    case activity = "/activities"
    case exercise = "/exercise"
    case assignment = "/assignment"
}
