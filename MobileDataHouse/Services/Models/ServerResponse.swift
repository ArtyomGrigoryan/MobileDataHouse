//
//  ServerResponse.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation

struct ServerResponse: Decodable {
    var results: [Results]
}

struct Results: Decodable {
    var urls: Urls
}

struct Urls: Decodable {
    let small: String
}
