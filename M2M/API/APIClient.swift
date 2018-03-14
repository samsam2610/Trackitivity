//
//  APIClient.swift
//  M2M
//
//  Created by Tran Sam on 2/20/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation
import RxSwift

class APIClient {
    
    func send<T: Codable>(apiRequest: APIRequest<T>) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.urlRequest
            let task = URLSession.shared.dataTask(with: request!) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


