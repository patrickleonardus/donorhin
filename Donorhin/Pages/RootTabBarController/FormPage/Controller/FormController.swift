//
//  FormController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class FormController: UIViewController{
  
  @IBOutlet weak var personalTableView: UITableView!
  @IBOutlet weak var detailTableView: UITableView!
  @IBOutlet weak var agreementLabel: UILabel!
  @IBOutlet weak var agreementSwitch: CheckBox!
  
  
  var formQuestionData : [FormQuestionNameModel]?
  var formPlaceholderData : [FormQuestionPlaceholderModel]?
  var formBloodType : [FormBloodTypeModel]?
  
  var viewValidationDelegate : ControlValidationViewDelegate?
  
  var submitBarButton : UIBarButtonItem?
  
  let pickerToolbar = UIToolbar()
  
  let dateFormatter = DateFormatter()
  var patientDueDateCast = Date()
  let now = Date()
  var patientEmergencyCast : Int64 = 0
  var patientBloodAmountCast : Int64 = 0
  
  var recordName : String?
  var patientName: String?
  var patientHospital: String?
  var patientHospitalId: CKRecord.ID?
  var patientBloodType: String?
  var patientDueDate: String?
  var patientBloodAmount: String?
  var patientEmergency: String = "0"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBar()
    setupToolbar()
    handleAgreement()
    handleKeyboard()
    checkmark()
    
    FormQuestionData().getFormQuestion { (formQuestionData) in
      self.formQuestionData = formQuestionData
    }
    
    FormQuestionData().getFormPlaceholder { (formPlaceholderData) in
      self.formPlaceholderData = formPlaceholderData
    }
    
    FormBloodType().getBloodType { (formBloodType) in
      self.formBloodType = formBloodType
    }
    
  }
  
  //MARK: - Setup UI
  
  func setNavBar(){
    let cancel = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(cancelAction))
    submitBarButton = UIBarButtonItem(title: "Konfirmasi", style: .done, target: self, action: #selector(submitAction))
    
    navigationItem.leftBarButtonItem = cancel
    navigationItem.rightBarButtonItem = submitBarButton
    
    submitBarButton?.isEnabled = false
  }
  
  private func setupToolbar(){
    pickerToolbar.isTranslucent = true
    pickerToolbar.sizeToFit()
    pickerToolbar.tintColor = Colors.red
    
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(pickerDoneBtnPressed))
    
    pickerToolbar.setItems([flexibleSpace, doneButton], animated: true)
  }
  
  @objc func pickerDoneBtnPressed() {
    closePickerView()
  }
  
  func closePickerView() {
    view.endEditing(true)
  }
  
  func handleAgreement(){
    agreementLabel.text = "Saya sudah mengajukan surat permintaan darah ke PMI"
  }
  
  func handleKeyboard(){
    let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  //MARK: - Setup CheckMark
  
  func checkmark(){
    agreementSwitch.isUserInteractionEnabled = true
    
    agreementSwitch.style = .tick
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(changeTicks(_:)))
    agreementSwitch.addGestureRecognizer(tap)
  }
  
  @objc func changeTicks(_ sender: UITapGestureRecognizer){
    if agreementSwitch.isChecked {
      agreementSwitch.isChecked = false
      checkValidity()
    }
    else if !agreementSwitch.isChecked {
      agreementSwitch.isChecked = true
      checkValidity()
    }
  }
  
  //MARK: - Handle date picker
  
  @objc func showDatePicker(sender: UITextField){
    let datePickerView : UIDatePicker = UIDatePicker()
    datePickerView.datePickerMode = UIDatePicker.Mode.date
    sender.inputView = datePickerView
    
    datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
  }
  
  @objc func datePickerValueChanged(sender: UIDatePicker){
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    
    if let cell = detailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as? LongLabelAndTextCell {
      cell.secondTextField.text = dateFormatter.string(from: sender.date)
    }
  }
  
  //MARK: - Handle validation
  
  func checkValidity(){
    
    if (patientName != nil &&
      patientHospital != nil &&
      patientBloodType != nil &&
      patientDueDate != nil &&
      patientBloodAmount != nil &&
      agreementSwitch.isChecked == true){
      
      submitBarButton?.isEnabled = true
      
    }
      
    else {
      submitBarButton?.isEnabled = false
    }
    
  }
  
  // casting blood amount
  
  
  func castingPatientBlood(){
    patientBloodAmountCast = Int64(patientBloodAmount!)!
  }
  
  func castingPatientEmergency(){
    patientEmergencyCast = Int64(patientEmergency)!
  }
  
  func castToDate(){
    dateFormatter.dateFormat = "dd MMM yyyy"
    patientDueDateCast = dateFormatter.date(from: patientDueDate!)!

  }
  
  //MARK: - Save to cloud kit
  
  func saveData(patientName : String, patientHospital: CKRecord.ID, patientBloodType: String, patientDueDate: Date, patientBloodAmount: Int64, patientEmergency: Int64, complete: @escaping (()->())){
    
    let userId = UserDefaults.standard.string(forKey: "currentUser")
    
    let record = CKRecord(recordType: "Request")
    record.setValue(CKRecord.Reference(recordID: CKRecord.ID(recordName: userId!), action: .none), forKey: "userId")
    record.setValue(patientDueDate, forKey: "date_need")
    record.setValue(patientBloodType, forKey: "patient_blood_type")
    record.setValue(patientEmergency, forKey: "isEmergency")
    record.setValue(CKRecord.Reference(recordID: patientHospital, action: .none), forKey: "UTD_patient")
    record.setValue(patientBloodAmount, forKey: "amount")
    record.setValue(patientName, forKey: "patient_name")
    
    let database = CKContainer.default().publicCloudDatabase
    
    database.save(record) { (record, error) in
      if error != nil {
        print("Error while saving data to CloudKit [FormController.swift].\n",error!.localizedDescription as Any)
        
        self.errorAlert(title: "Terjadi Kesalahan", message: "Tidak dapat melakukan request darah, mohon periksa kembali bagian yang sudah anda isi dan coba kembali dalam beberapa saat")
      }
      else {
        self.recordName = record?.recordID.recordName
        print("Successfully saved data to CloudKit")
        complete()
      }
    }
    
  }
  
  func createTrackerTable(){
    let record = CKRecord(recordType: "Tracker")
    
    let idRequest = CKRecord.Reference(recordID: CKRecord.ID(recordName: recordName!), action: .none)
    
    record.setValue(idRequest, forKey: "id_request")
    record.setValue(0, forKey: "current_step")
    let database = CKContainer.default().publicCloudDatabase
    
    database.save(record) { (record, error) in
      if error != nil {
        print("Error while creating tracker table [FormController.swift].\n",error!.localizedDescription as Any)
        
        self.errorAlert(title: "Terjadi Kesalahan", message: "Tidak dapat melakukan request darah, mohon periksa kembali bagian yang sudah anda isi dan coba kembali dalam beberapa saat")
      }
      else {
        print("Table tracker successfully updated")
      }
    }
  }
  
  func pushDataToCloudKit(){
    self.dismiss(animated: true) {
      self.viewValidationDelegate?.didRequestData()
      self.saveData(
        patientName: self.patientName!,
        patientHospital: self.patientHospitalId!,
        patientBloodType: self.patientBloodType!,
        patientDueDate: self.patientDueDateCast,
        patientBloodAmount: self.patientBloodAmountCast,
        patientEmergency: self.patientEmergencyCast, complete: {
          
          for count in 0...self.patientBloodAmountCast-1 {
            self.createTrackerTable()
          }
          
      })
    }

  }
  
  //MARK: - Action func
  
  @objc func cancelAction(){
    
    let alert = UIAlertController(title: "Peringatan", message: "Apakah anda yakin ingin membatalkan pengisian form surat darah?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Tidak", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Ya, Batalkan Pengisian Form Darah", style: .destructive, handler: { (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    self.present(alert,animated: true)
  }
  
  @objc func submitAction(){
    
    if !agreementSwitch.isChecked {
      errorAlert(title: "Peringatan", message: "Anda harus mengajukan surat permintaan darah ke PMI sebelum melakukan pencarian darah")
    }
      
    else if agreementSwitch.isChecked {
      
      // casting blood amount
      castingPatientBlood()
      
      // casting isEmergency
      castingPatientEmergency()
      
      // casting date to timestamp
      castToDate()
      
      let order = Calendar.current.compare(patientDueDateCast, to: now, toGranularity: .day)
      
      switch order {
      case .orderedAscending :
        errorAlert(title: "Salah Tanggal", message: "Tanggal kebutuhan darah yang anda masukan sudah lewat dari tanggal sekarang, periksa kembali tanggal kebutuhan yang anda isi")
        break
      case .orderedDescending:
        
        if patientEmergency == "0" {
          print("push to ck")
        }
        else if patientEmergency == "1" {
          errorAlert(title: "Peringatan", message: "Jika anda menyalakan tombol Kebutuhan Mendadak, maka tanggal kebutuhan darah harus sesuai dengan tanggal hari ini")
        }
      
        break
      case .orderedSame : print("push to ck")
        break
      }
    }
  }
  
  @objc func closeKeyboard(){
    view.endEditing(true)
  }
  
  func errorAlert(title: String, message: String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert,animated: true)
  }
  
  @IBAction func unwindFromSearch(segue: UIStoryboardSegue){
    
    let indexPath = IndexPath(row: 1, section: 0)
    let cell = personalTableView.cellForRow(at: indexPath) as! LabelAndTextCell
    cell.firstTextField.text = patientHospital
    personalTableView.reloadData()
    
  }
  
}


