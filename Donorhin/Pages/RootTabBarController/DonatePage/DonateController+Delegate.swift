//
//  DonateController+Delegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 04/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension DonateController : MoveToLoginFromDonate {
  
  func performLogin() {
    performSegue(withIdentifier: "moveToLoginFromDonate", sender: self)
  }
  
}
