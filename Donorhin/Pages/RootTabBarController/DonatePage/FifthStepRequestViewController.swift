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
  
  let thankYouLetter2 = "Anda sudah membantu satu nyawa hari ini! Terimakasih telah mendonorkan darah Anda. Resipien akan memberi kabar segera mengenai konfirmasi penerimaan darah."
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.thankyouLetter.text = thankYouLetter2
  }
  
  @IBAction func okeTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}
