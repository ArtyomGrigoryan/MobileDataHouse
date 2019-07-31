//
//  FoundPhotosModels.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

enum FoundPhotos {
    enum Model {
        struct Request {
            enum RequestType {
                case getPhotos
                case getNextPortion
            }
        }
        
        struct Response {
            enum ResponseType {
                case presentPhotos(photos: ServerResponse)
                case presentFailure(error: Error)
                case presentFooterLoader
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case displayPhotos(photosViewModel: PhotosViewModel)
                case displayFailure(error: String)
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
