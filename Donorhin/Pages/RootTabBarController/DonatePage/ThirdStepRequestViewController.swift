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
  
  @IBOutlet weak var firstLabel: UILabel!
  @IBOutlet weak var buttonCallRecipient: UIButton!
  @IBOutlet weak var buttonCallDonor: UIButton!
  
  var tracker: TrackerModel?
  
  var donorHospitalName : String?
  var donorHospitalPhone : String?
  
  var recipientHospitalName : String?
  var recipientHospitalPhone : String?
  
  var idUTDRecipient : CKRecord.ID?
  
  let database = CKContainer.default().publicCloudDatabase
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstLabel.changeFont(ofText: "wajib", with: UIFont.boldSystemFont(ofSize: 17))
  }
  
  override func recieveRequest(_ tracker: TrackerModel?) {
    self.tracker = tracker
    getDonorUTD()
  }
  
  func getDonorUTD(){
    
    let centerWidth = self.view.frame.width/2
    let centerHeight = (self.view.frame.height/2) - (self.view.frame.height/4)
    
    self.showSpinner(onView: self.view, x: Int(centerWidth), y: Int(centerHeight))
    guard let idUTD = tracker?.idUTDPendonor else {return}
    
    database.fetch(withRecordID: idUTD.recordID) { (records, error) in
      
      if error == nil {
        if let record = records {
          let models = record.convertUTDToUTDModel()
          
          guard let model = models else {fatalError()}
          
          self.donorHospitalName = model.name
          self.donorHospitalPhone = model.phoneNumbers![0]
          
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
    
    guard let idRequest = tracker?.idRequest else {return}
    
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
          self.recipientHospitalPhone = model.phoneNumbers![0]
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
    callNumber(phoneNumber: phone)
  }
  
  @objc func callRecipient(){
    guard let phone = recipientHospitalPhone else {return}
    callNumber(phoneNumber: phone)
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
