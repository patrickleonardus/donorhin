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
	
  //MARK:- Setup View
  override func viewDidLoad() {
    print ("is tracker model nil?",self.trackerModel == nil)
    super.viewDidLoad()
    setupView()
    self.showSpinner(onView: self.view, x: Int(UIScreen.main.bounds.width/2), y: Int(UIScreen.main.bounds.height/2))
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
	
	override func recieveRequest(_ tracker: TrackerModel?) {
		self.getDetailRequest(tracker?.idRequest)
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
      self.pageViewDelegate?.changeShowedView(toStep: 5,tracker: nil)
			if let token = self.tokenNotification,
				let idRequest = self.requestNotification {
				Service.sendNotification("Pendonor sudah melakukan donor darah", [token], idRequest, 0, self.currentUser)
			}
    }
    
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func setupAlertDecline() {
    let alert = UIAlertController(
      title: "Apakah Anda yakin ingin menolak?",
      message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
      preferredStyle: .alert
    )
    
    let accept = UIAlertAction(title: "Ya", style: .default) { (action) in
      //TODO: write code to decline here
    }
    
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
}
