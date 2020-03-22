//
//  HeaderCollectionReusableView.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 09.03.2020.
//  Copyright © 2020 Artyom Grigoryan. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    private var myView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var myLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.text = "Данные загружаются..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
        
        addSubview(myLabel)

        myLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
