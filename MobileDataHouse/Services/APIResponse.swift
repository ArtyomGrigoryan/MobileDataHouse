//
//  APIResponse.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 25/08/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case failure(String)
}
