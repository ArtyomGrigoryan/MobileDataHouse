//
//  FoundPhotosPresenter.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol FoundPhotosPresentationLogic {
    func presentData(response: FoundPhotos.Model.Response.ResponseType)
}

class FoundPhotosPresenter: FoundPhotosPresentationLogic {
    
    // MARK: - Public variables
    
    weak var viewController: FoundPhotosDisplayLogic?
  
    // MARK: - Logic
    
    func presentData(response: FoundPhotos.Model.Response.ResponseType) {
        switch response {
        case .presentPhotos(let photos):
            let cells = photos.results.map { (photo)  in
                cellViewModel(from: photo)
            }
            
            let photosViewModel = PhotosViewModel(cells: cells)
            
            viewController?.displayData(viewModel: .displayPhotos(photosViewModel: photosViewModel))
        case .presentFooterLoader:
            viewController?.displayData(viewModel: .displayFooterLoader)
        case .presentFailure(let error):
            viewController?.displayData(viewModel: .displayFailure(error: error))
        }
    }
  
    private func cellViewModel(from photo: Results) -> PhotosViewModel.Cell {
        let small = photo.urls.small
        
        return PhotosViewModel.Cell(small: small)
    }
}
