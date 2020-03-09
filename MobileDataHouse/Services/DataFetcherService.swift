//
//  DataFetcherService.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 21/09/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation

protocol DataFetcherServiceProtocol {
    func searchPhotos(query: String, page: String, response: @escaping (ServerResponse?, Error?) -> Void)
}

class DataFetcherService: DataFetcherServiceProtocol {
    let dataFetcher: DataFetcher!
    
    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func searchPhotos(query: String, page: String, response: @escaping (ServerResponse?, Error?) -> Void) {
        let parameters = ["client_id": API.key,
                          "query": query,
                          "page": page,
                          "per_page": API.perPage]
       
        dataFetcher.fetchJSONData(params: parameters, response: response)
    }
}
