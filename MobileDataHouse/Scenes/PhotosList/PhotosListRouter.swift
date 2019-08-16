//
//  PhotosListRouter.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 14/08/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol PhotosListRoutingLogic {
  
}

protocol PhotosListDataPassing {
    var dataStore: PhotosListDataStore? { get }
}

class PhotosListRouter: NSObject, PhotosListRoutingLogic, PhotosListDataPassing {

    // MARK: - Public variables
    
    var dataStore: PhotosListDataStore?
    weak var viewController: PhotosListViewController?

}
