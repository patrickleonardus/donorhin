//
//  FirstStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
class FirstStepRequestViewController: DonateStepViewController {
  var request: RequestModel!
  let currentUser = UserDefaults.standard.value(forKey: "currentUser")!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
   
   
   @IBAction func buttonAcceptTapped(_ sender: UIButton) {
      self.setupAlertAccept()
   }
   @IBAction func cancelButtonTapped(_ sender: UIButton) {
      self.setupAlertDecline()
   }
   
   private func setupAlertAccept() {
      let alert = UIAlertController(
         title: "Apakah Anda yakin bersedia?",
         message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
         preferredStyle: .alert
      )
      
      let acceptAction = UIAlertAction(title: "Ya", style: .default) { (action) in
        let ckRecord = CKRecord(recordType: "Tracker")
        ckRecord.setValue(CKRecord.Reference(recordID: self.request.idRequest, action: .none), forKey: "id_request")
        ckRecord.setValue(CKRecord.Reference(recordID: CKRecord.ID(recordName: self.currentUser as! String), action: .none), forKey: "id_pendonor")
        self.showSpinner(onView: self.view)
        Helper.saveData(ckRecord) { (isSuccess) in
          if isSuccess {
            self.removeSpinner()
            self.dismiss(animated: true, completion: nil)
          }
          else {
            self.removeSpinner()
            self.dismiss(animated: true, completion: nil)
          }
        }
        
      }
      let cancelAction = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
      alert.addAction(acceptAction)
      alert.addAction(cancelAction)
      self.present(alert, animated: true, completion: nil)
   }
   
   private func setupAlertDecline() {
      let alert = UIAlertController(
         title: "Apakah Anda yakin ingin menolak?",
         message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
         preferredStyle: .alert
      )
      let accept = UIAlertAction(title: "Ya", style: .default) { (_) in
        self.dismiss(animated: true, completion: nil)
      }
      let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
      alert.addAction(accept)
      alert.addAction(cancel)
      self.present(alert, animated: true, completion: nil)
   }
}
