//
//  SearchPhotosRouter.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

@objc protocol SearchPhotosRoutingLogic {
    func routeToFoundPhotos(segue: UIStoryboardSegue)
}

protocol SearchPhotosDataPassing {
    var dataStore: SearchPhotosDataStore? { get }
}

class SearchPhotosRouter: NSObject, SearchPhotosRoutingLogic, SearchPhotosDataPassing {

    // MARK: - Public variables
    
    var dataStore: SearchPhotosDataStore?
    weak var viewController: SearchPhotosViewController?
  
    // MARK: - Routing
  
    func routeToFoundPhotos(segue: UIStoryboardSegue) {
        let dvc = segue.destination as! FoundPhotosViewController
        var destinationDS = dvc.router!.dataStore!
        passDataToFoundPhotos(source: dataStore!, destination: &destinationDS)
    }
    
    func passDataToFoundPhotos(source: SearchPhotosDataStore, destination: inout FoundPhotosDataStore) {
        destination.userQuery = source.userQuery
    }
}
