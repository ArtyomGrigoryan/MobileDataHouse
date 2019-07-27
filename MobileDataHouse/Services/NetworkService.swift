//
//  NetworkService.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(from: API.searchPhotos, params: params)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
   
        return components.url!
    }
}
