//
//  FoundPhotosRouter.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol FoundPhotosRoutingLogic {

}

protocol FoundPhotosDataPassing {
    var dataStore: FoundPhotosDataStore? { get }
}

class FoundPhotosRouter: NSObject, FoundPhotosRoutingLogic, FoundPhotosDataPassing {
    
    // MARK: - Public variables
    
    var dataStore: FoundPhotosDataStore?
    weak var viewController: FoundPhotosViewController?
    
}
