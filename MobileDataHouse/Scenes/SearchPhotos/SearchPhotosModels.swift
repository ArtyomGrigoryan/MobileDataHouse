//
//  SearchPhotosModels.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

enum SearchPhotos {
    enum Model {
        struct Request {
            enum RequestType {
                case passUserQuery(userQuery: String)
            }
        }
   
        struct Response {
            enum ResponseType {
                case success
                case failure(error: String)
            }
        }
    
        struct ViewModel {
            enum ViewModelData {
                case success
                case presentFailure(error: String)
            }
        }
    }
}
