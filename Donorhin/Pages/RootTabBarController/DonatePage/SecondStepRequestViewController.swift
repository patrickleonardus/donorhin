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
  @IBOutlet var tapRecognizer: UITapGestureRecognizer!
  @IBOutlet var buttonBersedia: CustomButtonRounded!
  @IBOutlet weak var UTDLabel: UILabel!
  
  
  
  var chosenHospital : HospitalModel?
  var chosenUTD: DonatePMIModel?
  var picker = UIDatePicker()
  var tracker: TrackerModel?
  var isFilled : Bool {
    get {
      let text1 = chosenDate
      let text2 = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text
      if (text1 != nil && text2 != nil) {
        return true
        //TODO: Call function save to db here
      } else {
        return false
      }
    }
  }
  var chosenDate : Date? {
    didSet {
      let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
      cell.accessoryView = .none
      let desc = self.chosenDate?.description.prefix(10)
      cell.detailTextLabel?.text = String(desc ?? "")
    }
  }
  var database = CKContainer.default().publicCloudDatabase
  //MARK:- Styling View
  override func viewDidLoad() {
    super.viewDidLoad()
    generalStyling()
    UTDLabel.text = "Unit Transfusi Darah \nSalah satu unit PMI yang melayani pendonoran darah"
  }
  
  override func recieveRequest(_ tracker: TrackerModel?) {
    self.tracker = tracker
  }
  
  func generalStyling () {
    stylingTableView()
    picker.styling()
    self.tapRecognizer.isEnabled = false
    self.buttonBersedia.isEnabled = isFilled
  }
  
  //MARK:- Setting up Table View
  private func stylingTableView () {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.isScrollEnabled = false
    self.tableView.backgroundColor = .white
    self.tableView.separatorStyle = .singleLine
    self.tableView.layer.cornerRadius = 10
  }
  
  //MARK:- Setting up date picker
  func showDatePicker () {
    self.tapRecognizer.isEnabled = true
    picker.datePickerMode = .date
    picker.minimumDate = Date()
    self.view.addSubview(picker)
    self.constrainingDatePicker()
    self.view.bringSubviewToFront(picker)
    self.picker.addTarget(self, action: #selector(datePickerDidChanged), for: .valueChanged)
  }
  
  @objc private func datePickerDidChanged () {
    self.chosenDate = picker.date
    self.buttonBersedia.isEnabled = isFilled
  }
  
  private func constrainingDatePicker() {
    let safeArea = self.view.safeAreaLayoutGuide
    picker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      picker.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      picker.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      picker.heightAnchor.constraint(equalToConstant: picker.frame.height),
      picker.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
  
  @IBAction func closeDatePicker(_ sender: Any) {
    self.picker.removeFromSuperview()
    self.tapRecognizer.isEnabled = false
    self.tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
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
              guard let track = self?.tracker else {return}
              guard let recordNameUTD = self?.chosenHospital?.id else {return}
              self?.showSpinner(onView: self!.view)
              
              //FIXME: Ubah record name masih di hard code

              self?.database.fetch(withRecordID: track.idTracker, completionHandler: { [weak self] (record, error) in
                if let record = record {
                  record.setValue(CKRecord.Reference(recordID: recordNameUTD, action: .none), forKey: "id_UTD_pendonor")
                  record.setValue(self?.chosenDate, forKey: "donor_date")
                  self?.database.save(record) { (recordSave, err) in
                    if err != nil {
                      print ("Error while saving data", err)
                    }
                    if let recordSave = recordSave {
                      DispatchQueue.main.async {
                        self?.pageViewDelegate?.changeShowedView(toStep: 3,tracker: nil)
                        self?.removeSpinner()
                      }
                    }
                  }
                }
              })
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
