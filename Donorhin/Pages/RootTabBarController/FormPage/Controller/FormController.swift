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
  
  //MARK: - IBOutlets
  @IBOutlet weak var personalTableView: UITableView!
  @IBOutlet weak var emergencyLabel: UILabel!
  @IBOutlet weak var emergencySwitch: UISwitch!
  @IBOutlet weak var agreementLabel: UILabel!
  @IBOutlet weak var agreementSwitch: CheckBox!
  @IBOutlet weak var scroller: UIScrollView!
  
  
  //MARK: - global variables
  var formQuestionData : [FormQuestionNameModel]?
  var formPlaceholderData : [FormQuestionPlaceholderModel]?
  var formBloodType : [FormBloodTypeModel]?
  
  var viewValidationDelegate : ControlValidationViewDelegate?
  var refreshData : FetchRequestData?
  
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
  var currentPlace = UserDefaults.standard.string(forKey: "province")
	var currentUser = UserDefaults.standard.string(forKey: "currentUser")
  var notification: CKRecord?
  
  //MARK: - view controller lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setNavBar()
    setupToolbar()
    handleLabelUI()
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
  
  //MARK: - send push notification
  func sendNotification(_ message: String,_ bloodType: String,_ idRequest: String?) {
    let nspredicate = NSPredicate(format: "province = %@ AND blood_type = %@", argumentArray: [self.currentPlace!,bloodType])
    let query = CKQuery(recordType: "Account", predicate: nspredicate)
    Helper.getAllData(query) { (results) in
      var tokens:[String] = []
      if let results = results {
        if results.count > 0 {
          for item in results {
            if let token = item.value(forKey: "device_token") as? String {
              tokens.append(token)
            }
          }
        }
      }
      DispatchQueue.main.asyncAfter(deadline: .now()+2) {
        guard let idRequest = self.recordName else {return}
        Service.sendNotification(message, tokens,idRequest,1,self.currentUser!) // send notification to server
      }
    }
  }
  
  //MARK: - Setup UI
  
  func setupUI(){
    personalTableView.tableFooterView = UIView()
  }
  
  @objc func onKeyboardAppear(_ notification: NSNotification) {
    let info = notification.userInfo!
    let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
    let kbSize = rect.size
    
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height-40, right: 0)
    scroller.contentInset = insets
    scroller.scrollIndicatorInsets = insets
    
  }

  @objc func onKeyboardDisappear(_ notification: NSNotification) {
    scroller.contentInset = UIEdgeInsets.zero
    scroller.scrollIndicatorInsets = UIEdgeInsets.zero
  }
  
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
  
  func handleLabelUI(){
    agreementLabel.text = "Saya sudah mengajukan surat permintaan darah ke PMI"
    emergencyLabel.text = "Kebutuhan Mendadak"
  }
  
  func handleKeyboard(){
    let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
    view.addGestureRecognizer(tap)
    
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    datePickerView.minimumDate = Date()
    sender.inputView = datePickerView
    
    datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
  }
  
  @objc func datePickerValueChanged(sender: UIDatePicker){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    
    if let cell = personalTableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as? LabelAndTextCell {
      cell.firstTextField.text = dateFormatter.string(from: sender.date)
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
    record.setValue(CKRecord.Reference(recordID: CKRecord.ID(recordName: "0"), action: .none), forKey: "id_pendonor")
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
  
  func pushDataToCloudKit(completion: @escaping () -> Void){
    
    self.showSpinner(onView: view.self)
    
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
          
          if count == self.patientBloodAmountCast-1 {
            self.sendNotification("Terdapat kebutuhan kantong darah \(self.patientBloodType!) untuk tanggal \(self.patientDueDateCast.dateToString()). Apakah Anda bersedia mendonor?",self.patientBloodType!,self.recordName)
            
            self.removeSpinner()
            completion()
          }
          
        }
        
    })
    
   

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
    
    if patientBloodAmount == "0"{
      errorAlert(title: "Kesalahan Input", message: "Silahkan periksa kembali jumlah kantung darah yang anda butuhkan")
    }
    else {
      
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
          pushDataToCloudKit {
            DispatchQueue.main.async {
              self.dismiss(animated: true, completion: {
                self.refreshData?.fetchRequestData()
              })
            }
          }
          break
        case .orderedSame :
          
          if patientEmergency == "0" {
            errorAlert(title: "Perhatian", message: "Jika anda membutuhkan darah untuk hari ini, anda dapat menyalakan tombol Kebutuhan Mendesak untuk dapat diprioritaskan")
          }
          else if patientEmergency == "1" {
            pushDataToCloudKit {
              DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                  self.refreshData?.fetchRequestData()
                })
              }
            }
          }
          break
        }
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
  
  
  @IBAction func emergencyAction(_ sender: Any) {
    
    let indexPath = IndexPath(row: 3, section: 0)
    let cell = personalTableView.cellForRow(at: indexPath) as! LabelAndTextCell
    
    if emergencySwitch.isOn {
      
      patientEmergency = "1"
  
      //buat ngeset harinya jadi besok setelah hari ini.
      let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: now)
      dateFormatter.dateFormat = "dd MMM yyyy"
      
      let tommorowString = dateFormatter.string(from: tommorow!)
      let todayString = dateFormatter.string(from: now)
      
      cell.firstTextField.text = todayString
      cell.firstTextField.isEnabled = false
      patientDueDate = tommorowString
      
      checkValidity()
      
    }
    else {
      
      patientEmergency = "0"
      
      cell.firstTextField.text = ""
      cell.firstTextField.isEnabled = true
      patientDueDate = nil
      
      checkValidity()
      
    }
  }
  
  @IBAction func unwindFromSearch(segue: UIStoryboardSegue){
    
    let indexPath = IndexPath(row: 1, section: 0)
    let cell = personalTableView.cellForRow(at: indexPath) as! LabelAndTextCell
    cell.firstTextField.text = patientHospital
    personalTableView.reloadData()
    
  }
  
}


