//
//  CustomButtonRounded.swift
//  Donorhin
//
//  Created by Idris on 06/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
// this custom button for button submit 
@IBDesignable
class CustomButtonRounded: UIButton {
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.setupButton()
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
      self.setupButton()
   }
   
   //MARK: - setup button
   private func setupButton() {
    self.layer.backgroundColor = UIColor(red: 179/255, green: 0, blue: 27/255, alpha: 1).cgColor
    self.layer.cornerRadius = 10
    self.backgroundColor = Colors.red
   }
}
