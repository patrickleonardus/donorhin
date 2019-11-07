//
//  CustomMainView.swift
//  Donorhin
//
//  Created by Idris on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
@IBDesignable
class CustomMainView: UIView {
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
    self.layer.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1).cgColor
  }
}
