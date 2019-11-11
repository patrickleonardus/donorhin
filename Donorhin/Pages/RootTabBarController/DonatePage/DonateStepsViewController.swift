//
//  DonateStepsViewController.swift
//  Donorhin
//
//  Created by Idris on 11/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DonateStepsViewController: UIViewController {
  var request:Request?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let request = request {
      self.title = request.user
    }
  }
}
