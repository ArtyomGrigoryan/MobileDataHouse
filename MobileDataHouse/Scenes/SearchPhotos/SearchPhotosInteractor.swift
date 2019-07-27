//
//  SearchPhotosInteractor.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol SearchPhotosBusinessLogic {
    func makeRequest(request: SearchPhotos.Model.Request.RequestType)
}

protocol SearchPhotosDataStore {
    var userQuery: String! { get }
}

class SearchPhotosInteractor: SearchPhotosBusinessLogic, SearchPhotosDataStore {
    
    // MARK: - Public variables
    
    var userQuery: String!
    var presenter: SearchPhotosPresentationLogic?
    
    // MARK: - Private variables
    
    private let emptyTextFieldErrorMessage = "Пожалуйста, напишите что-нибудь в текстовое поле."
  
    // MARK: - Logic
    
    func makeRequest(request: SearchPhotos.Model.Request.RequestType) {
        switch request {
        case .passUserQuery(let userQuery):
            let userQuery = userQuery.trimmingCharacters(in: .whitespaces)
            
            if userQuery.isEmpty {
                self.presenter?.presentData(response: .failure(error: emptyTextFieldErrorMessage))
            } else {
                self.userQuery = userQuery
                self.presenter?.presentData(response: .success)
            }
        }
    }
}
