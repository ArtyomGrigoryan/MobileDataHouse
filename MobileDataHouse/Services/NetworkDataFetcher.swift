//
//  NetworkDataFetcher.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func searchPhotos(query: String, page: String, response: @escaping (ServerResponse?, Error?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func searchPhotos(query: String, page: String, response: @escaping (ServerResponse?, Error?) -> Void) {
        let params = ["client_id": API.key,
                      "query": query,
                      "page": page,
                      "per_page": API.perPage]
        
        networking.request(path: API.searchPhotos, params: params) { (data, error) in
            if let error = error {
                response(nil, error)
            }
            
            let decoded = self.decodeJSON(type: ServerResponse.self, from: data)
            response(decoded, nil)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
