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

extension FindController : FetchRequestData {
  
  func fetchRequestData() {
    timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fetchAllDataForTimer), userInfo: nil, repeats: true)
  }
  
}

extension FindController : MoveToLoginFromFind {
  
  func performLogin() {
    self.performSegue(withIdentifier: "MoveToLogin", sender: self)
  }
  
}
