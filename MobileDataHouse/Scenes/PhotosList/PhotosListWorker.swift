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
        page = "1"
        networking = NetworkService()
        fetcher = NetworkDataFetcher(networking: networking)
    }
    
    func searchPhotos(query: String, completion: @escaping (Response<ServerResponse>) -> Void) {
        fetcher.searchPhotos(query: query, page: page) { [weak self] (serverResponse, error) in
            guard let self = self, let response = serverResponse else {
                return completion(.failure(error!.localizedDescription))
            }
            // В self.response потом будем аппендить новые картинки из других страниц (page)
            self.response = response
            completion(.success(response))
        }
    }
    
    
    func getNextPortion(query: String, page: String, completion: @escaping (Response<ServerResponse>) -> Void) {
        fetcher.searchPhotos(query: query, page: page) { [weak self]  (serverResponse, error) in
            guard let self = self, let response = serverResponse else {
                return completion(.failure(error!.localizedDescription))
            }
            
            if self.response == nil {
                self.response = response
            } else {
                // Добавляем в self.response новые картинки, полученные с новых страниц (page)
                self.response!.results.append(contentsOf: response.results)
            }
            
            completion(.success(self.response!))
        }
    }
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }
}
