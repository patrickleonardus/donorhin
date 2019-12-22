//
//  TrackerController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class TrackerController : UIViewController {
  
  @IBOutlet weak var trackerTableView: UITableView!
  
  var input: SearchTrackerInput?
  var trackerModel : TrackerModel? {
    didSet {
      if trackerModel != nil {
        self.input?.step = trackerModel!.currentStep
      }
    }
  }
  var utdDonor: UTDModel?
  var utdPatient: UTDModel?
  var reqData: RequestModel?
  
  var stepItems : [StepItems]?
  var status : [Status]?  = []
  var navigationBarTitle: String?
	let currentUser: String = UserDefaults.standard.value(forKey: "currentUser") as! String
  
  //MARK: Override View
  override func viewDidLoad() {
    super.viewDidLoad()
    super.view.backgroundColor = Colors.backgroundView
    self.showSpinner(onView: self.view)
    self.loadData {
      self.removeSpinner()
      self.setNavBarTitle()
      self.getTrackerItems { (stepItems) in
        print ("complete")
        self.stepItems = stepItems
        self.loadTableView()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    self.navigationController?.navigationBar.prefersLargeTitles = false
    setTabBar(show: false)
  }
  
  
  
  //MARK: Data Loader
  func loadData(completionHandler: @escaping (() -> Void) ) {
    DispatchQueue.main.async {
      self.loadTrackerData {
        self.loadDonorUTDData() {
          self.loadRequestData{
            self.loadPatientUtdData{
              print ("loadData")
              completionHandler()
            }
          }
        }
      }
    }
  }
  
  func loadTrackerData(completionHandler: @escaping (() -> Void) ) {
    if let input = input {
      DispatchQueue.main.async {
        Helper.getDataByID(input.idTracker) { (record) in
          self.trackerModel = record?.convertTrackerToTrackerModel()
          print ("loadTrackerData isNil:\(self.trackerModel == nil)")
          completionHandler()
        }
      }
    }
  }
  
  func loadDonorUTDData(completionHandler: @escaping ( () -> Void )) {
    if let input = input {
      DispatchQueue.main.async {
        Helper.getDataByID(input.patientUtdId) { (record) in
          self.utdDonor = record?.convertUTDToUTDModel()
          completionHandler()
        }
      }
    }
  }
  
  func loadRequestData(completionHandler: @escaping ( () -> Void )) {
    if let input = input {
      DispatchQueue.main.async {
        Helper.getDataByID(input.idRequest) { (record) in
          self.reqData = record?.convertRequestToRequestModel()
          completionHandler()
        }
      }
    }
  }
  
  func loadPatientUtdData(completionHandler: @escaping (() -> Void)){
    DispatchQueue.main.async {
      Helper.getDataByID((self.reqData?.idUTDPatient)!){ (record) in
        self.utdPatient = record?.convertUTDToUTDModel()
        completionHandler()
      }
    }
  }
  
  func setTabBar(show: Bool){
    if show {
      UIView.animate(withDuration: 0.2) {
        self.tabBarController?.tabBar.alpha = 1
      }
    }
    else {
      UIView.animate(withDuration: 0.2) {
        self.tabBarController?.tabBar.alpha = 0
      }
    }
  }
  
  func setNavBarTitle(){
    DispatchQueue.main.async {
      self.navigationItem.title = self.navigationBarTitle
    }
  }
  
  func loadTableView(){
    DispatchQueue.main.async {
      self.trackerTableView.delegate = self
      self.trackerTableView.dataSource = self
      self.trackerTableView.register(UINib(nibName: "TrackerDonorTableViewCell", bundle: nil), forCellReuseIdentifier: "trackerCell")
      self.trackerTableView.tableFooterView = UIView()
      self.trackerTableView.reloadData()
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
  
  @objc func callPMIResepien(){
    
    guard let phone = self.utdPatient?.phoneNumbers else { fatalError() }
    
    if phone.count > 1 {
      
      let alert = UIAlertController(title: "Nomor Telepon Unit Transfusi Darah", message: "Silahkan pilih salah satu nomor telepon dibawah ini", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
      
      for number in 0...phone.count - 1 {
        alert.addAction(UIAlertAction(title: "✆ " + phone[number], style: .default, handler: { (action) in
          self.callNumber(phoneNumber: phone[number])
        }))
      }
      self.present(alert,animated: true)
    }
    else if phone.count == 1 {
      callNumber(phoneNumber: phone[0])
    }
  }
  
  @objc func callPMIPendonor(){
    
    guard let phone = self.utdDonor?.phoneNumbers else { fatalError() }
    
    if phone.count > 1 {
      
      let alert = UIAlertController(title: "Nomor Telepon Unit Transfusi Darah", message: "Silahkan pilih salah satu nomor telepon dibawah ini", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
      
      for number in 0...phone.count - 1 {
        alert.addAction(UIAlertAction(title: "✆ " + phone[number], style: .default, handler: { (action) in
          self.callNumber(phoneNumber: phone[number])
        }))
      }
      self.present(alert,animated: true)
    }
    else if phone.count == 1 {
      callNumber(phoneNumber: phone[0])
    }
    
  }
  
  func getTrackerItems(completionHandler: @escaping (([StepItems]) -> ())) {
    settingUpStatus {
      DispatchQueue.main.async {
        print("getTrackerItems")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let date = dateFormatter.string(from: (self.trackerModel?.donorDate)!)
        
        
        completionHandler(
          [StepItems(
            description: "Anda dapat memberitahukan PMI bahwa Anda menggunakan aplikasi untuk mencari donor",
            buttonStr: "Hubungi \(String(describing: self.utdPatient!.name))",
            status: self.status![0]
            ),
           
           StepItems(
            description: "Pendonor Anda Telah Ditemukan Lokasi: \(String(describing: self.utdDonor!.name)) Mendonor pada \(date)",
            buttonStr: "Hubungi \(String(describing: self.utdDonor!.name))",
            status: self.status![1]),
           
           StepItems(
            description: "Pendonor Akan Melakukan Verifikasi Kelengkapan Surat",
            buttonStr: "",
            status: self.status![2]),
           
           StepItems(
            description: "Donor Sukses! Mohon untuk konfirmasi apabila sudah mendapatkan kantong darah",
            buttonStr: " Konfirmasi",
            status: self.status![3]),
           
           StepItems(
            description: "Ayo Gabung Dengan Komunitas Rhesus Negatif",
            buttonStr: " More info",
            status: self.status![4])
          ]
        )
      }
    }
    
  }
  
  func settingUpStatus(completionHandler: @escaping ( () -> Void )) {
    switch self.input?.step {
    case 1:
      self.status = [.onGoing, .toDo, .toDo, .toDo, .toDo]
    case 2:
      self.status = [.done, .onGoing, .toDo, .toDo, .toDo]
    case 3:
      self.status = [.done, .done, .onGoing, .toDo, .toDo]
    case 4:
      self.status = [.done, .done, .done, .onGoing, .toDo]
    default:
      self.status = [.done, .done, .done, .done, .done]
    }
    completionHandler()
  }
  
}

