//
//  ThirdStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class ThirdStepRequestViewController: DonateStepViewController {
  
  @IBOutlet weak var firstLabel: UILabel!
  @IBOutlet weak var buttonAcceptOutlet: UIButton!
  @IBOutlet weak var buttonCancelOutlet: UIButton!
  
  var tracker: TrackerModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstLabel.changeFont(ofText: "wajib", with: UIFont.boldSystemFont(ofSize: 17))
    
  }
  
  override func recieveRequest(_ tracker: TrackerModel?) {
    self.tracker = tracker
  }
  
  @IBAction func buttonAcceptTapped(_ sender: UIButton) {
    let alert = UIAlertController(
      title: "Apakah Anda yakin bersedia?",
      message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
      preferredStyle: .alert
    )
    
    let accept = UIAlertAction (
      title: "Ya",
      style: .default) { (alert) in
        //TODO: Write code to accept here
        self.pageViewDelegate?.changeShowedView(toStep: 4,tracker: nil)
    }
    
    let cancel = UIAlertAction(
      title: "Tidak",
      style: .cancel,
      handler: nil
    )
    
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func buttonCancelTapped(_ sender: UIButton) {
    let alert = UIAlertController(
      title: "Apakah Anda yakin ingin menolak?",
      message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
      preferredStyle: .alert
    )
    
    let accept = UIAlertAction (
    title: "Ya",
    style: .default) { (action) in
      //TODO: Write code to decline here
    }
    
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
}
