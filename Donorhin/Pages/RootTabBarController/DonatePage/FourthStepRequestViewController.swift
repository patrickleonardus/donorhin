//
//  FourthStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class FourthStepRequestViewController: DonateStepViewController {
  
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var sudahDonorButton: CustomButtonRounded!
  @IBOutlet weak var cancelButton: UIButton!
  
  
  var requestNotification: String?
	var tokenNotification: String?
	var currentUser = UserDefaults.standard.value(forKey: "currentUser") as! String
	var tracker: TrackerModel?
	
  //MARK:- Setup View
  override func viewDidLoad() {
    print ("is tracker model nil?",self.trackerModel == nil)
    super.viewDidLoad()
    setupView()
    
    let centerWidth = self.view.frame.width/2
    let centerHeight = (self.view.frame.height/2) - (self.view.frame.height/4)
    self.showSpinner(onView: self.view, x: Int(centerWidth), y: Int(centerHeight))
		
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.hideAllView(true)
  }
  
  func hideAllView(_ hide: Bool) {
    self.textLabel.isHidden = hide
    self.sudahDonorButton.isHidden = hide
    self.cancelButton.isHidden = hide
  }
  
  //MARK:- Load UTD Name
  
  func setupView() {
    getUTDName { (utdName) in
      DispatchQueue.main.async {
        if let utdName = utdName {
          self.textLabel.text = "Silahkan mendonorkan darah Anda di \(utdName)"
          self.removeSpinner()
          self.hideAllView(false)
        }
      }
    }
  }
  func getUTDName (completionHandler : @escaping ( (String?) -> Void )){
    guard let idUTDPendonor = self.trackerModel?.idUTDPendonor?.recordID else {completionHandler(nil);return}

    Helper.getDataByID(idUTDPendonor) { (recordUTD) in
      guard let utdModel = recordUTD?.convertUTDToUTDModel() else {
        completionHandler(nil)
        return
      }
      completionHandler(utdModel.name)
    }
  }
	
	//MARK: - initiate data for send notification
	private func getDetailRequest(_ idRequest: CKRecord.Reference?) {
    guard let idRequest = idRequest else {return}
		self.requestNotification = idRequest.recordID.recordName
		Helper.getDataByID(idRequest.recordID) { (records) in
			if let record = records {
				let userId = record.value(forKey: "userId") as! CKRecord.Reference
				Helper.getDataByID(userId.recordID) {[weak self] (recordAccount) in
					if let recordAccount = recordAccount {
						let deviceToken = recordAccount.value(forKey: "device_token") as! String
						self?.tokenNotification = deviceToken
					}
				}
			}
		}
  }
  
  @IBAction func buttonAcceptTapped(_ sender: UIButton) {
    self.setupAlertAccept()
  }
  @IBAction func buttonCancelTapped(_ sender: UIButton) {
    self.setupAlertDecline()
  }
  
  private func setupAlertAccept() {
    let alert = UIAlertController(
      title: "Apakah Anda sudah selesai mendonor?",
      message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
      preferredStyle: .alert
    )
    
    let accept = UIAlertAction( title: "Ya", style: .default) { (action) in
      //TODO:  Write code to accept here
			guard let track = self.trackerModel else {return}
			Helper.getDataByID(track.idTracker) { (responseTracker) in
				if let _ = responseTracker {
					var params: [String:Any] = [:]
					params["current_step"] = 4
					self.trackerModel?.currentStep = 5
					DispatchQueue.main.async {
						self.pageViewDelegate?.changeShowedView(keyValuePair: params, tracker: self.trackerModel)
						self.sendNotification()
					}
				}
			}
    }
    
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
	
	//MARK: - Send Notification
	func sendNotification() {
		if let token = self.tokenNotification,
			let idRequest = self.requestNotification {
			Service.sendNotification("Pendonor sudah melakukan donor darah", [token], idRequest, 0, self.currentUser)
		}
	}
  
  private func setupAlertDecline() {
    let alert = UIAlertController(
      title: "Apakah Anda yakin ingin menolak?",
      message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
      preferredStyle: .alert
    )
    
    let accept = UIAlertAction(title: "Ya", style: .default) { (action) in
      //TODO: write code to decline here
			guard let track = self.trackerModel else {return}
			
			var params:[String:Any] = [:]
			params["id_pendonor"] = CKRecord.ID(recordName: "0")
			params["current_step"] = 0
			params["id_UTD_pendonor"] = CKRecord.ID(recordName: "")
			params["donor_date"] = ""
			Helper.updateToDatabase(keyValuePair: params, recordID: track.idTracker)
			self.navigationController?.popViewController(animated: true)
    }
    
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
}
