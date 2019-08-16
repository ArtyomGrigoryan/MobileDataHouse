//
//  SearchPhotosPresenter.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol SearchPhotosPresentationLogic {
    func presentData(response: SearchPhotos.Model.Response.ResponseType)
}

class SearchPhotosPresenter: SearchPhotosPresentationLogic {
    
    // MARK: - Public variables
    
    weak var viewController: SearchPhotosDisplayLogic?
  
    // MARK: - SearchPhotosPresentationLogic
    
    func presentData(response: SearchPhotos.Model.Response.ResponseType) {
        switch response {
        case .success:
            viewController?.displayData(viewModel: .success)
        case .failure(let error):
            viewController?.displayData(viewModel: .presentFailure(error: error))
        }
    }
}
