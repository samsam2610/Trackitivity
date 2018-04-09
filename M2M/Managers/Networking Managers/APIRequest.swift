//
//  APIRequest.swift
//  M2M
//
//  Created by Tran Sam on 2/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case GET, POST
}



class APIRequest<T: Codable> {
    // associatedtype Data where Data: Codable
    let urlString: URL
    var method: RequestType
    var path: String
    var parameters = [String : String]()
    var urlRequest: URLRequest?
    var data: T?
    
    init(urlString: URL, method: RequestType, path: String, data: T) {
        self.urlString = urlString
        self.method = method
        self.path = path
        self.data = data
        self.urlRequest = request(data)
    }
    
    init(urlString: URL, method: RequestType, path: String, parameters: [String: String], data: T) {
        self.urlString = urlString
        self.method = method
        self.path = path
        self.parameters = parameters
        self.data = data
        self.urlRequest = request(data)
    }
    
    
    func request<V: Codable>(_ data: V) -> URLRequest {
        guard var components = URLComponents(url: urlString.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        if method.rawValue == "GET" {
            components.percentEncodedQuery = parameters.map { "?conditions=" + "{\"\($0)\":\"\($1)\"}".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!}.joined(separator: "&")
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method.rawValue == "POST" {
            do {
                let jsonData = try JSONEncoder().encode(data)
                request.httpBody = jsonData
            } catch {
                print("encoding data failed")
                print(error)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if method.rawValue == "GET" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
}
