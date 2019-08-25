//
//  WebImageView.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    func set(imageURL: String?) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            return
        }

        //проверим лежит ли изображение в кэше
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            //если да, то не нужно заново подгружать картинки (return)
            return
        }
        
        //реализуем функционал загрузки изображения из интернета
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let response = response, let self = self {
                    self.image = UIImage(data: data)
                    //если изображения в кэше не оказалось, то поместим его в кэш
                    self.handleLoadingImage(data: data, response: response)
                }
            }
        }.resume()
    }
    
    private func handleLoadingImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        //создадим кэшированный ответ
        let cachedResponse = CachedURLResponse(response: response, data: data)
        //обратимся к объекту, который будет хранить наш кэш
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
