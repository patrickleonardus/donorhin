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
  
  var input: SearchTrackerInput? {
    didSet {
      print (input)
    }
  }
  var trackerModel : TrackerModel?
  var utdDonor: UTDModel?
  var utdPatient: UTDModel?
  
  var stepItems : [StepItems]?
//  var bloodRequest : [BloodRequest]?
  var donorData : [Pendonor]? //FIXME: Delete
  var status : [Status]?  = []
  var navigationBarTitle: String?
  
  
  //MARK: Override View
  override func viewDidLoad() {
    super.viewDidLoad()
    super.view.backgroundColor = Colors.backgroundView
    self.showSpinner(onView: self.view)
    self.loadData {
      self.removeSpinner()
      self.setNavBarTitle()
      //
      //      PendonorDummyData().getCurrentPendonor { (donorData) in
      //        self.donorData = donorData
      //      }
      self.getTrackerItems { (stepItems) in
        print ("complete")
        self.stepItems = stepItems
        self.loadTableView()
      }
      //      DispatchQueue.main.async {
      //        self.trackerTableView.showsVerticalScrollIndicator = false
      //      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    self.navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  
  
  //MARK: Data Loader
  func loadData(completionHandler: @escaping (() -> Void) ) {
    DispatchQueue.main.async {
      self.loadTrackerData {
        self.loadDonorUTDData() {
          self.loadPatientUtdData{
            print ("loadData")
            completionHandler()
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
    if input != nil {
      DispatchQueue.main.async {
        if let idUtdDonor = self.trackerModel?.idUTDPendonor.recordID {
          Helper.getDataByID(idUtdDonor) { (record) in
            self.utdDonor = record?.convertUTDToUTDModel()
            print("loadDonorUTDData isNil:\(self.utdDonor==nil)")
            completionHandler()
          }
        }
      }
    }
  }
  
  func loadPatientUtdData(completionHandler: @escaping ( () -> Void )) {
    if let input = input {
      DispatchQueue.main.async {
        Helper.getDataByID(input.patientUtdId) { (record) in
          self.utdPatient = record?.convertUTDToUTDModel()
          print("loadPatientUtdData isNil \(self.utdPatient==nil)")
          completionHandler()
        }
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
    callNumber(phoneNumber: "56789")
  }
  
  @objc func callPMIPendonor(){
    callNumber(phoneNumber: "12345")
  }
  
  func getTrackerItems(completionHandler: @escaping (([StepItems]) -> ())) {
    settingUpStatus {
      DispatchQueue.main.async {
        print("getTrackerItems")
        completionHandler(
          [StepItems(
            description: "Anda dapat memberitahukan PMI bahwa Anda menggunakan aplikasi untuk mencari donor",
            buttonStr: " Hubungi \(String(describing: self.utdPatient!.name))",
            status: self.status![0]
            ),
           
           StepItems(
            description: "Pendonor Anda Telah Ditemukan Lokasi: \(String(describing: self.utdDonor!.name)) Mendonor pada \(String(describing: self.trackerModel!.donorDate))",
            buttonStr: " Hubungi \(String(describing: self.utdDonor!.name))",
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

