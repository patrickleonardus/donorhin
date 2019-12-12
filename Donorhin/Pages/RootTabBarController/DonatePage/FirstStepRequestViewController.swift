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
  var tracker: TrackerModel?
  let currentUser = UserDefaults.standard.value(forKey: "currentUser")!
  @IBOutlet weak var descriptionLabel: UILabel!
  let database = CKContainer.default().publicCloudDatabase
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func recieveRequest(_ tracker: TrackerModel?) {
    self.tracker = tracker
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
      let acceptAction = UIAlertAction(title: "Ya", style: .default) { [weak self] (action) in
        guard let track = self?.tracker else {return}
        self?.showSpinner(onView: self!.view)
        let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: "0"), action: .none)
        let idRequest = CKRecord.ID(recordName: track.idRequest.recordID.recordName)
        let query = CKQuery(recordType: "Tracker", predicate: NSPredicate(format: "id_request == %@ AND id_pendonor == %@", idRequest,reference))
        Helper.getAllData(query) { (results) in
          if let results = results {
            if results.count > 0 {
              guard let result = results.first else {return}
              guard let current = self!.currentUser as? String else {return}
              self?.database.fetch(withRecordID: result.recordID, completionHandler: { [weak self] (record, error) in
                if let record = record {
                  record.setValue(CKRecord.Reference(recordID: CKRecord.ID(recordName: current), action: .none), forKey: "id_pendonor")
                  record.setValue(2, forKey: "current_step")
                  self?.database.save(record) { (recordSave, err) in
                    if let recordSave = recordSave {
                      DispatchQueue.main.async {
                        self?.pageViewDelegate?.changeShowedView(toStep: 2)
                        self?.removeSpinner()
                      }
                    }
                  }
                }
              })
            }
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
