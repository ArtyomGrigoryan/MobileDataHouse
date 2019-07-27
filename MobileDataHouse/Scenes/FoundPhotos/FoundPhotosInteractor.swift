//
//  FoundPhotosInteractor.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol FoundPhotosBusinessLogic {
    func makeRequest(request: FoundPhotos.Model.Request.RequestType)
}

protocol FoundPhotosDataStore {
    var userQuery: String! { get set }
}

class FoundPhotosInteractor: FoundPhotosBusinessLogic, FoundPhotosDataStore {
  
    // MARK: - Public variables
    
    var page = 1
    var userQuery: String!
    var service: FoundPhotosService?
    var presenter: FoundPhotosPresentationLogic?
  
    // MARK: - Logic
    
    func makeRequest(request: FoundPhotos.Model.Request.RequestType) {
        if service == nil {
            service = FoundPhotosService()
        }
        
        switch request {
        // В этом кейсе по умолчанию грузится 1 (первая) страница выдачи по запросу.
        case .getPhotos:
            service?.searchPhotos(query: userQuery, completion: { [weak self] (response, error) in
                if let response = response {
                    self?.presenter?.presentData(response: .presentPhotos(photos: response))
                } else {
                    self?.presenter?.presentData(response: .presentFailure(error: error!.localizedDescription))
                }
            })
        // В этом кейсе грузятся последующие страницы.
        case .getNextPortion:
            page += 1
            self.presenter?.presentData(response: .presentFooterLoader)
            service?.getNextPortion(query: userQuery, page: String(describing: page), completion: { [weak self] (response, error) in
                if let response = response {
                    self?.presenter?.presentData(response: .presentPhotos(photos: response))
                } else {
                    self?.presenter?.presentData(response: .presentFailure(error: error!.localizedDescription))
                }
            })
        }
    }
}
