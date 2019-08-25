//
//  UIToolbar + toolbarPicker.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 27/07/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

extension UIToolbar {
    func toolbarPicker(mySelect: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.barStyle = .default
        toolbar.tintColor = .black
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
}
