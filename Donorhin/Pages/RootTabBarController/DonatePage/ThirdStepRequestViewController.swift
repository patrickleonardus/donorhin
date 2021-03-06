//
//  ThirdStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class ThirdStepRequestViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func buttonAcceptTapped(_ sender: UIButton) {
    self.setupAlertAccept()
  }
  
  @IBAction func buttonCancelTapped(_ sender: UIButton) {
    self.setupAlertDecline()
  }
  
  private func setupAlertAccept() {
    let alert = UIAlertController(title: "Apakah Anda yakin bersedia?", message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda", preferredStyle: .alert)
    let accept = UIAlertAction(title: "Ya", style: .default) { (_) in
      
    }
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func setupAlertDecline() {
    let alert = UIAlertController(title: "Apakah Anda yakin ingin menolak?", message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda", preferredStyle: .alert)
    let accept = UIAlertAction(title: "Ya", style: .default) { (_) in
      
    }
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
}
