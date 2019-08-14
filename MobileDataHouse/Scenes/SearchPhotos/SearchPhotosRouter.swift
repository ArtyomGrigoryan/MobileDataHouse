//
//  SearchPhotosRouter.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

@objc protocol SearchPhotosRoutingLogic {
    func routeToPhotosList(segue: UIStoryboardSegue)
}

protocol SearchPhotosDataPassing {
    var dataStore: SearchPhotosDataStore? { get }
}

class SearchPhotosRouter: NSObject, SearchPhotosRoutingLogic, SearchPhotosDataPassing {

    // MARK: - Public variables
    
    var dataStore: SearchPhotosDataStore?
    weak var viewController: SearchPhotosViewController?
  
    // MARK: - Routing
  
    func routeToPhotosList(segue: UIStoryboardSegue) {
        let dvc = segue.destination as! PhotosListViewController
        var destinationDS = dvc.router!.dataStore!
        passDataToPhotosList(source: dataStore!, destination: &destinationDS)
    }
    
    func passDataToPhotosList(source: SearchPhotosDataStore, destination: inout PhotosListDataStore) {
        destination.userQuery = source.userQuery
    }
}
