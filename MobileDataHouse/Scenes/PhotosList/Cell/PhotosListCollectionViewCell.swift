//
//  PhotosListCollectionViewCell.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 14/08/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol PhotosListCellViewModel {
    var small: String { get }
}

class PhotosListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var photoImageView: WebImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(viewModel: PhotosListCellViewModel) {
        photoImageView.set(imageURL: viewModel.small)
    }
}
