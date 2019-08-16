//
//  PhotosListModels.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 14/08/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

enum PhotosList {
    enum Model {
        struct Request {
            enum RequestType {
                case getPhotos
                case clearCache
                case getNextPortion
            }
        }
   
        struct Response {
            enum ResponseType {
                case presentAlertController(title: String, message: String?)
                case presentPhotos(photos: ServerResponse)
                case presentFooterLoader
            }
        }
  
        struct ViewModel {
            enum ViewModelData {
                case displayAlertController(title: String, message: String?)
                case displayPhotos(photosViewModel: PhotosViewModel)
                case displayFooterLoader
            }
        }
    }
}

struct PhotosViewModel {
    struct Cell: PhotosListCellViewModel {
        var small: String
    }
    
    let cells: [Cell]
}
