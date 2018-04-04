//
//  NetworkHelper.swift
//  M2M
//
//  Created by Victor Zhong on 3/21/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class NetworkHelper {
    private init() {}
    static let manager = NetworkHelper()
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)

    func performDataTask(with url: URL, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (AppError) -> Void) {
        urlSession.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    errorHandler(AppError.other(rawError: error))
                    return
                }

                if let response = response as? HTTPURLResponse, response.statusCode < 200, response.statusCode > 300 {
                    errorHandler(AppError.badStatusCode(num: response.statusCode))
                    return
                }

                if let data = data {
                    completionHandler(data)
                }
            }
            }.resume()
    }

    func performDataTask(with request: URLRequest, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (AppError) -> Void) {
        urlSession.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    errorHandler(AppError.other(rawError: error))
                    return
                }

                if let response = response as? HTTPURLResponse, response.statusCode < 200, response.statusCode > 300 {
                    errorHandler(AppError.badStatusCode(num: response.statusCode))
                    return
                }

                if let data = data {
                    completionHandler(data)
                }
            }
            }.resume()
    }
}

