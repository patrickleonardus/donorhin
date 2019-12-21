//
//  ThirdStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class ThirdStepRequestViewController: DonateStepViewController {
  
  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!
  @IBOutlet weak var buttonCallRecipient: UIButton!
  @IBOutlet weak var buttonCallDonor: UIButton!
  @IBOutlet weak var confirmButton: CustomButtonRounded!
  @IBOutlet weak var cancelButton: UIButton!
  
  var donorHospitalName : String?
  var donorHospitalPhone : [String]?
  
  var recipientHospitalName : String?
  var recipientHospitalPhone : [String]?
  
  var idUTDRecipient : CKRecord.ID?
  var requestNotification: String?
	var tokenNotification: String?
  let database = CKContainer.default().publicCloudDatabase
	var currentUser: String = UserDefaults.standard.value(forKey: "province") as! String
  
  var infoText1 : String {
    self.hideAllElement(false)
    guard let recUTDName = recipientHospitalName , let bloodType = UserDefaults.standard.string(forKey: "blood_type") else {return "Sebelum Anda mendonor, anda wajib menghubungi PMI untuk menanyakan (verifikasi) kebeneran adanya kebutuhan permintaan darah" }
    return "Sebelum Anda mendonor, anda wajib menghubungi \(recUTDName) untuk menanyakan (verifikasi) kebeneran adanya kebutuhan permintaan darah \(bloodType)"
  }
  
  var infoText2 : String {
    guard let dnrUTD = donorHospitalName else {return ""}
    return "Informasikan \(dnrUTD) bahwa Anda akan melakukan donor darah"
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    generalStyling()
  }
  
  override func viewWillAppear(_ animated: Bool) {
		self.getDonorUTD()
    hideAllElement(true)
  }
  
  func hideAllElement (_ hide: Bool) {
    self.label2.isHidden = hide
    self.label1.isHidden = hide
    self.buttonCallDonor.isHidden = hide
    self.buttonCallRecipient.isHidden = hide
    self.cancelButton.isHidden = hide
    self.confirmButton.isHidden = hide
  }
  
  //MARK:- Styling
  func generalStyling() {
    label1.changeFont(ofText: "wajib", with: UIFont.boldSystemFont(ofSize: 17))
    
  }
	
	//MARK:- initiate data for send notification
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
  
  func getDonorUTD(){
    
    let centerWidth = self.view.frame.width/2
    let centerHeight = (self.view.frame.height/2) - (self.view.frame.height/4)
    self.showSpinner(onView: self.view, x: Int(centerWidth), y: Int(centerHeight))
    
		guard let idUTD = self.trackerModel?.idUTDPendonor else {return}
    
    database.fetch(withRecordID: idUTD.recordID) { (records, error) in
      
      if error == nil {
        if let record = records {
          let models = record.convertUTDToUTDModel()
          
          guard let model = models else {fatalError()}
          
          self.donorHospitalName = model.name
          self.donorHospitalPhone = model.phoneNumbers
          self.getRequestData()
          
        }
      }
      
      else if error != nil {
        print("Error occured when fetch donor UTD data")
        self.removeSpinner()
      }
    }
  }
  
  func getRequestData(){
    
		guard let idRequest = self.trackerModel?.idRequest else {return}
    
    database.fetch(withRecordID: idRequest.recordID) { (records, error) in
      if error == nil {
        if let record = records {
          let models = record.convertRequestToRequestModel()
          
          guard let model = models else {fatalError()}
          
          self.idUTDRecipient = model.idUTDPatient
          
          self.getRecipientUTD()
        }
      }
      else if error != nil {
        print("Error occured while fetching request data")
        self.removeSpinner()
      }
    }
  }
  
  func getRecipientUTD(){
    
    guard let idUTD = idUTDRecipient else {fatalError()}
    
    database.fetch(withRecordID: idUTD) { (records, error) in
      if error == nil {
        if let record = records {
          let models = record.convertUTDToUTDModel()
          
          guard let model = models else {fatalError()}
          
          self.recipientHospitalName = model.name
          self.recipientHospitalPhone = model.phoneNumbers
          self.removeSpinner()
          
          self.setCallButton()
          self.setCallAction()
        }
      }
      else if error != nil {
        print("Error occured while fetching recipient UTD data")
        self.removeSpinner()
      }
    }
    
  }
  
  func setCallButton(){
    
    DispatchQueue.main.async {
      self.buttonCallDonor.setTitle(" \(String(describing: self.donorHospitalName!))", for: .normal)
      self.buttonCallRecipient.setTitle(" \(String(describing: self.recipientHospitalName!))", for: .normal)
      
      self.label1.text = self.infoText1
      self.label2.text = self.infoText2
      
    }
  }
  
  func setCallAction(){
    
    DispatchQueue.main.async {
      self.buttonCallDonor.addTarget(self, action: #selector(self.callDonor), for: .touchUpInside)
      self.buttonCallRecipient.addTarget(self, action: #selector(self.callRecipient), for: .touchUpInside)
    }
    
  }
  
  @objc func callDonor(){
    guard let phone  = donorHospitalPhone else {return}
    
    if phone.count > 1 {
      let alert = UIAlertController(title: "Nomor Telepon Unit Transfusi Darah", message: "Silahkan pilih salah satu nomor telepon dibawah ini", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
      
      for phoneNumber in 0...phone.count - 1{
        alert.addAction(UIAlertAction(title: "✆ " + phone[phoneNumber], style: .default, handler: { (action) in
          self.callNumber(phoneNumber: phone[phoneNumber])
        }))
      }
      self.present(alert,animated: true)
    }
    else if phone.count == 1 {
      callNumber(phoneNumber: phone[0])
    }
  }
  
  @objc func callRecipient(){
    guard let phone = recipientHospitalPhone else {return}
    
    if phone.count > 1 {
      let alert = UIAlertController(title: "Nomor Telepon Unit Transfusi Darah", message: "Silahkan pilih salah satu nomor telepon dibawah ini", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
      
      for phoneNumber in 0...phone.count - 1{
        alert.addAction(UIAlertAction(title: "✆ " + phone[phoneNumber], style: .default, handler: { (action) in
          self.callNumber(phoneNumber: phone[phoneNumber])
        }))
      }
      self.present(alert,animated: true)
    }
    else if phone.count == 1 {
      callNumber(phoneNumber: phone[0])
    }
  }
  
  private func callNumber(phoneNumber: String){
    if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
      let application:UIApplication = UIApplication.shared
      if (application.canOpenURL(phoneCallURL)) {
        application.open(phoneCallURL, options: [:], completionHandler: nil)
      }
    }
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
				self.showSpinner(onView: self.view)
				guard let track = self.trackerModel else {return}
				
				Helper.getDataByID(track.idTracker) { (responseTracker) in
					if let _ = responseTracker {
						var params: [String:Any] = [:]
						params["current_step"] = 3
						self.trackerModel?.currentStep = 4
						DispatchQueue.main.async {
							self.pageViewDelegate?.changeShowedView(keyValuePair: params, tracker: self.trackerModel)
						}
					}
				}
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
	
	func updateToDatabase() {
		if let token = self.tokenNotification,
			let idRequest = self.requestNotification {
			Service.sendNotification("Pendonor sudah melakukan verifikasi", [token], idRequest, 0, self.currentUser)
		}
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
