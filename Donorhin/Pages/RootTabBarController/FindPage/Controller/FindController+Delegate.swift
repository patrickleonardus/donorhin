//
//  FindController+Delegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 16/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FindController : ControlValidationViewDelegate {
  
  func didRequestData() {
    
  }
  
}

extension FindController : MoveToLogin {
  
  func performLogin() {
    self.performSegue(withIdentifier: "MoveToLogin", sender: self)
  }
  
}
