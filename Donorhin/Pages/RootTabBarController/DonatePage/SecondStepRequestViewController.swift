//
//  SecondStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
class SecondStepRequestViewController: DonateStepViewController{
  //MARK:- Variables
  @IBOutlet var tableView: UITableView!
  @IBOutlet var buttonBersedia: CustomButtonRounded!
  @IBOutlet weak var UTDLabel: UILabel!
  
  var chosenHospital : HospitalModel?
  var chosenUTD: DonatePMIModel?
  var tracker: TrackerModel?
	var requestNotification: String?
	var tokenNotification: String?
  var chosenDate : Date? {
    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LabelWithTextFieldTableViewCell
    guard let date = cell?.dateList?.last else {return nil}
    return date
  }
  
	var currentUser: String = UserDefaults.standard.value(forKey: "currentUser") as! String
  var isFilled : Bool {
    get {
      let text1 = chosenDate
      let text2 = chosenHospital
      if (text1 != nil && text2 != nil) {
        return true
        //TODO: Call function save to db here
      } else {
        return false
      }
    }
  }
  
  var database = CKContainer.default().publicCloudDatabase
  //MARK:- Styling View
  override func viewDidLoad() {
    super.viewDidLoad()
    generalStyling()
  }
  
  func generalStyling () {
    UTDLabel.text = "UTD = Unit Transfusi Darah \nSalah satu unit PMI yang melayani pendonoran darah"
    UTDLabel.changeFont(ofText: "UTD = Unit Transfusi Darah", with: UIFont.boldSystemFont(ofSize: 15))
    stylingTableView()
    self.buttonBersedia.isEnabled = isFilled
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
  
  //MARK:- Setting up Table View
  private func stylingTableView () {
    self.tableView.register(UINib(nibName: "LabelWithTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.isScrollEnabled = false
    self.tableView.backgroundColor = .white
    self.tableView.separatorStyle = .singleLine
    self.tableView.layer.cornerRadius = 10
  }
  
  
  
  //MARK: - Action of pressed button
  @IBAction func buttonAcceptTapped(_ sender: UIButton) {
    self.setupAlertAccept()
    
  }
  @IBAction func buttonCancelTapped(_ sender: UIButton) {
    self.setupAlertDecline()
  }
  
  private func setupAlertAccept() {
    if let date = chosenDate {
      if let datestr = date.description(with: .none).formattedDate{
        if let UTD = self.chosenHospital?.name {
          let alert = UIAlertController(
            //FIXME: Tampilin pilihan UTD yang tadi dan kapan dia mau donor
            title: "Apakah data sudah sesuai?",
            message: "Anda akan mendonorkan darah pada tanggal \(datestr), di \(UTD). Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
            preferredStyle: .alert
          )
          
          let accept = UIAlertAction(
            title: "Ya",
            style: .default) {[weak self] (action) in
              guard let track = self?.trackerModel else {return}
              guard let recordNameUTD = self?.chosenHospital?.id else {return}
              
              let centerWidth = self!.view.frame.width/2
              let centerHeight = (self!.view.frame.height/2) - (self!.view.frame.height/4)
              self!.showSpinner(onView: self!.view, x: Int(centerWidth), y: Int(centerHeight))
              
              //FIXME: Ubah record name masih di hard code
							Helper.getDataByID(track.idTracker) { (responseTracker) in
								if let _ = responseTracker {
									var params: [String:Any] = [:]
									params["id_UTD_pendonor"] = CKRecord.Reference(recordID: recordNameUTD, action: .none)
									params["donor_date"] = self?.chosenDate
									params["current_step"] = 2
									
									self?.trackerModel?.currentStep = 3
									self?.trackerModel?.idUTDPendonor = CKRecord.Reference(recordID: recordNameUTD, action: .none)
									self?.trackerModel?.donorDate = self?.chosenDate
									DispatchQueue.main.async {
										self?.pageViewDelegate?.changeShowedView(keyValuePair: params, tracker: self?.trackerModel)
										self?.sendNotification(date: datestr, utd: UTD)
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
      }
    }
  }
	
	//MARK: - Send Notification
	func sendNotification(date: String, utd: String) {
		if let token = self.tokenNotification,
			let idRequest = self.requestNotification {
			Service.sendNotification("Pendonor akan mendonor di \(utd) pada tanggal \(date)", [token], idRequest, 0, self.currentUser)
		}
	}
  
  private func setupAlertDecline() {
    let alert = UIAlertController(
      title: "Apakah Anda yakin ingin menolak?",
      message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda",
      preferredStyle: .alert
    )
    
    let accept = UIAlertAction(
      title: "Ya",
      style: .default) { (_) in
        //TODO: Tolak request
				self.navigationController?.popViewController(animated: true)
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
}
