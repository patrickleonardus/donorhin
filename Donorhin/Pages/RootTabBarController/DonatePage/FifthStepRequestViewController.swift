//
//  FifthStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FifthStepRequestViewController: DonateStepViewController {
  var step : Int?
  @IBOutlet var okButton: CustomButtonRounded!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let step = step {
      if step  > 5 {
        self.okButton.isHidden = true
      } else {
        self.okButton.isHidden = false
      }
    }
  }
  
  @IBAction func okeTapped(_ sender: Any) {
    self.pageViewDelegate?.changeShowedView(toStep: 6)
    self.okButton.isHidden =  true
  }
  
}
