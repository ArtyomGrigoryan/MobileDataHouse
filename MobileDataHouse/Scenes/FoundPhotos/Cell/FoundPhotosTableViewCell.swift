//
//  FoundPhotosTableViewCell.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol PhotosListCellViewModel {
    var small: String { get }
}

class FoundPhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: WebImageView!
    
    override func prepareForReuse() {
        photoImageView.set(imageURL: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(viewModel: PhotosListCellViewModel) {
        photoImageView.set(imageURL: viewModel.small)
    }
}
