//
//  CustomSegmentedController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
@IBDesignable
class CustomSegmentedController: UISegmentedControl {
    
    //MARK: ini untuk custom segmented control jadi warna merah
    
    override func prepareForInterfaceBuilder() {
        self.setupSegmentedController()
    }
    
    override func awakeFromNib() {
        self.setupSegmentedController()
    }
    
    // MARK: - setup view
    private func setupSegmentedController() {
        self.tintColor = UIColor(red: 179/255, green: 0, blue: 27/255, alpha: 1)
    }
}
