//
//  PhotosListPresenter.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 14/08/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol PhotosListPresentationLogic {
    func presentData(response: PhotosList.Model.Response.ResponseType)
}

class PhotosListPresenter: PhotosListPresentationLogic {
  
    // MARK: - Public variables
    
    weak var viewController: PhotosListDisplayLogic?
  
    // MARK: - PhotosListPresentationLogic
    
    func presentData(response: PhotosList.Model.Response.ResponseType) {
        switch response {
        case .presentPhotos(let photos):
            let cells = photos.results.map { (photo)  in
                cellViewModel(from: photo)
            }
            
            let photosViewModel = PhotosViewModel(cells: cells)
            
            viewController?.displayData(viewModel: .displayPhotos(photosViewModel: photosViewModel))
        case .presentFooterLoader:
            viewController?.displayData(viewModel: .displayFooterLoader)
        case .presentAlertController(let title, let message):
            viewController?.displayData(viewModel: .displayAlertController(title: title, message: message))
        }
    }
    
    private func cellViewModel(from photo: Results) -> PhotosViewModel.Cell {
        let small = photo.urls.small
        
        return PhotosViewModel.Cell(small: small)
    }
}
