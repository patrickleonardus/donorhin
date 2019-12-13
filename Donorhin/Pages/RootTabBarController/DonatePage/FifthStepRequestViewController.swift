//
//  FifthStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FifthStepRequestViewController: DonateStepViewController {
  @IBOutlet var okButton: CustomButtonRounded!
  
  @IBOutlet var thankyouLetter: UILabel!
  var step : Int?
  
  let thankYouLetter2 = "Anda sudah membantu satu nyawa lagi hari ini! Terimakasih telah mendonorkan darah Anda"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let step = self.step {
      if step > StepsEnum.donoring_4 {
        self.okButton.isHidden = true
        self.thankyouLetter.text = thankYouLetter2
      } else {
        self.okButton.isHidden = false
      }
    }
  }
  
  @IBAction func okeTapped(_ sender: Any) {
    self.pageViewDelegate?.changeShowedView(toStep: 6,tracker: nil)
    self.step = self.step! + 1
    self.thankyouLetter.text = thankYouLetter2

    self.okButton.isHidden =  true
  }
  
}
