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
        
        guard let service = service, let presenter = self.presenter else { return }
        switch request {
        // В этом кейсе по умолчанию грузится 1 (первая) страница выдачи по запросу.
        case .getPhotos:
            service.searchPhotos(query: userQuery) { [weak self] (response) in
                switch response {
                case .success(let response):
                    presenter.presentData(response: .presentPhotos(photos: response))
                case .failure(let error):
                    guard let self = self else { return }
                    presenter.presentData(response: .presentAlertController(title: error, message: self.errorMessage))
                }
            }
        // В этом кейсе грузятся последующие страницы.
        case .getNextPortion:
            page += 1
            presenter.presentData(response: .presentFooterLoader)
            service.getNextPortion(query: userQuery, page: String(describing: page)) { [weak self] (response) in
                switch response {
                case .success(let response):
                    presenter.presentData(response: .presentPhotos(photos: response))
                case .failure(let error):
                    guard let self = self else { return }
                    presenter.presentData(response: .presentAlertController(title: error, message: self.errorMessage))
                }
            }
        // В этом кейсе чистится кэш.
        case .clearCache:
            service.clearCache()
            let title = "Кэш очищен!"
            presenter.presentData(response: .presentAlertController(title: title, message: nil))
        }
    }
}
