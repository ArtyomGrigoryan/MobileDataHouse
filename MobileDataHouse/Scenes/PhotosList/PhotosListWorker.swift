//
//  PhotosListWorker.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 14/08/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class PhotosListService {
    private var response: ServerResponse?
    private var networking: Networking
    private var fetcher: DataFetcher
    private var page: String
    
    init() {
        self.page = "1"
        self.networking = NetworkService()
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    func searchPhotos(query: String, completion: @escaping (ServerResponse?, Error?) -> Void) {
        fetcher.searchPhotos(query: query, page: page) { [weak self] (serverResponse, error) in
            if let serverResponse = serverResponse {
                // В self.response потом будем аппендить новые картинки из других страниц (page)
                self?.response = serverResponse
                guard let response = self?.response else { return }
                completion(response, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getNextPortion(query: String, page: String, completion: @escaping (ServerResponse?, Error?) -> Void) {
        fetcher.searchPhotos(query: query, page: page) { [weak self]  (serverResponse, error) in
            if let serverResponse = serverResponse {
                if self?.response == nil {
                    self?.response = serverResponse
                } else {
                    // Добавляем в self.response новые картинки, полученные с новых страниц (page)
                    self?.response?.results.append(contentsOf: serverResponse.results)
                }
                
                guard let response = self?.response else { return }
                completion(response, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }
}
