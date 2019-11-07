//
//  CustomViewRounded.swift
//  Donorhin
//
//  Created by Idris on 06/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

// This custom view to configure cell view
@IBDesignable
class CustomViewRounded: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForInterfaceBuilder() {
    self.setupView()
  }
  
  override func awakeFromNib() {
    self.setupView()
  }
  
  // MARK: - setup view
  private func setupView() {
    self.layer.cornerRadius = 10
    self.layer.backgroundColor = UIColor.white.cgColor
  }
}
