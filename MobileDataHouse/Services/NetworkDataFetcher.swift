//
//  NetworkDataFetcher.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func fetchJSONData<T: Decodable>(params: [String: String], response: @escaping (T?, Error?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    let networking: Networking
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func fetchJSONData<T: Decodable>(params: [String: String], response: @escaping (T?, Error?) -> Void) {
        networking.request(path: API.searchPhotos, params: params) { (data, error) in
            guard let data = data else {
                return response(nil, error)
            }
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded, nil)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(type.self, from: data)
        } catch let error {
            print("Error is: ", error)
            return nil
        }
    }
}
