//
//  FifthStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FifthStepRequestViewController: DonateStepViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func setupAlertAccept() {
    let alert = UIAlertController(title: "Terima kasih", message: "Anda sudah menyelamatkan nyawa seseorang hari ini", preferredStyle: .alert)
    let accept = UIAlertAction(title: "Ya", style: .default,handler: nil)
    alert.addAction(accept)
    self.present(alert, animated: true, completion: nil)
  }
}
