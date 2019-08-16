//
//  PhotosListInteractor.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 14/08/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol PhotosListBusinessLogic {
    func makeRequest(request: PhotosList.Model.Request.RequestType)
}

protocol PhotosListDataStore {
    var userQuery: String! { get set }
}

class PhotosListInteractor: PhotosListBusinessLogic, PhotosListDataStore {

    // MARK: - Public variables
    
    var userQuery: String!
    var service: PhotosListService?
    var presenter: PhotosListPresentationLogic?
    
    // MARK: - Private variables
    
    private var page = 1
    private let errorMessage = "Повторите попытку."
  
    // MARK: - PhotosListBusinessLogic
    
    func makeRequest(request: PhotosList.Model.Request.RequestType) {
        if service == nil {
            service = PhotosListService()
        }
        
        switch request {
        // В этом кейсе по умолчанию грузится 1 (первая) страница выдачи по запросу.
        case .getPhotos:
            service?.searchPhotos(query: userQuery, completion: { [weak self] (response, error) in
                if let response = response {
                    self?.presenter?.presentData(response: .presentPhotos(photos: response))
                } else {
                    let title = error!.localizedDescription
                    self?.presenter?.presentData(response: .presentAlertController(title: title, message: self?.errorMessage))
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
                    let title = error!.localizedDescription
                    self?.presenter?.presentData(response: .presentAlertController(title: title, message: self?.errorMessage))
                }
            })
        // В этом кейсе чистится кэш.
        case .clearCache:
            service?.clearCache()
            let title = "Кэш очищен!"
            self.presenter?.presentData(response: .presentAlertController(title: title, message: nil))
        }
    }
}
