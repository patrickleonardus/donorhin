//
//  InboxController+Delegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension InboxController : MoveToLoginFromInbox {
  
  func performLogin() {
    performSegue(withIdentifier: "moveToLoginFormInbox", sender: self)
  }
  
}
