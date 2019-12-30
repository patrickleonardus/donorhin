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
	let currentUser = UserDefaults.standard.string(forKey: "currentUser")
  @IBOutlet weak var descriptionLabel: UILabel!
	var requestNotification: String?
	var tokenNotification: String?
	var senderTokenNotification: String?
	var dateNeed: Date?
	var bloodType: String?
	
  override func viewDidLoad() {
    super.viewDidLoad()
		self.getDetailRequest()
  }
  
	//MARK: - initiate data for send notification
  private func getDetailRequest() {
		guard let request = self.trackerModel else {return}
		self.showSpinner(onView: self.view)
		self.requestNotification = request.idRequest.recordID.recordName
		Helper.getDataByID(request.idRequest.recordID) { (records) in
			if let record = records {
				let userId = record.value(forKey: "userId") as! CKRecord.Reference
				self.dateNeed = record.value(forKey: "date_need") as? Date
				self.bloodType = record.value(forKey: "blood_type") as? String
				
				if let dateNeed = self.dateNeed, let bloodType = self.bloodType {
					self.descriptionLabel.text = "Terdapat kebutuhan kantong darah \(bloodType) untukk tanggal \(dateNeed.dateToString()). Apakah Anda siap mendonor?"
				}

				Helper.getDataByID(userId.recordID) {[weak self] (recordAccount) in
					if let recordAccount = recordAccount {
						let deviceToken = recordAccount.value(forKey: "device_token") as! String
						self?.tokenNotification = deviceToken
						self?.removeSpinner()
					}
					else {
						self?.removeSpinner()
					}
				}
			}
		}
  }
  
  @IBAction func buttonAcceptTapped(_ sender: UIButton) {
    self.setupAlertAccept()
  }
  @IBAction func cancelButtonTapped(_ sender: UIButton) {
    self.setupAlertDecline()
  }
  @IBAction func termsButtonAction(_ sender: Any) {
    performSegue(withIdentifier: "moveToInfoFromFirstStep", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "moveToInfoFromFirstStep" {
      let destination = segue.destination as! InformationController
      destination.navigationBarTitle = "Daftar Syarat Pendonor"
    }
    
  }
   
   private func setupAlertAccept() {
      let alert = UIAlertController(
         title: "Apakah Anda yakin bersedia?",
         message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
         preferredStyle: .alert
      )
      let acceptAction = UIAlertAction(title: "Ya", style: .default) { (action) in
        guard let track = self.trackerModel,
					let current = self.currentUser else
				{
					return
				}
        let centerWidth = self.view.frame.width/2
        let centerHeight = (self.view.frame.height/2) - (self.view.frame.height/4)
        self.showSpinner(onView: self.view, x: Int(centerWidth), y: Int(centerHeight))
				
				Helper.getDataByID(track.idTracker) { (responseTracker) in
					if let _ = responseTracker {
						var params: [String: Any] = [:]
						params["id_pendonor"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: current), action: .none)
						params["current_step"] = 1
						self.trackerModel?.idPendonor = CKRecord.Reference(recordID: CKRecord.ID(recordName: current), action: .none)
						self.trackerModel?.currentStep = 2
						DispatchQueue.main.async {
							self.pageViewDelegate?.changeShowedView(keyValuePair: params, tracker: self.trackerModel)
							self.sendNotification()
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
				self.navigationController?.popViewController(animated: true)
      }
      let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
      alert.addAction(accept)
      alert.addAction(cancel)
      self.present(alert, animated: true, completion: nil)
   }
	
	//MARK: -  Send Notification
	func sendNotification() {
		if let token = self.tokenNotification,
			let idRequest = self.requestNotification {
			Service.sendNotification("Pendonor bersedia mendonor", [token], idRequest, 0,self.currentUser!)
		}
	}
}
