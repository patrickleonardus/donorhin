//
//  RegisterDetailController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

class RegisterDetailController : UIViewController, CLLocationManagerDelegate {
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    var userCredentials:[String:String] = [:]
    var detailUserCredentials:[String:String] = [:]
    var rootViewController: UIViewController?
    @IBOutlet weak var formTableView: UITableView!
    let generalPicker = UIPickerView()
    let database = CKContainer.default().publicCloudDatabase
    let datePicker = UIDatePicker()
    let gender = ["Pria","Wanita"]
    let bloodType = ["A-","A+","B-","B+","O-","O+","AB-","AB+", "Belum Diketahui"]
    var pickerToolBar: UIToolbar!
    var activeCell : FormTableViewCell?
    var activeTextfield : UITextField?
    let locationManager = CLLocationManager()
    var editMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FormBuilder().getItemsForRegisterDetail { (formItems) in
            self.formItems = formItems
        }
        self.title = "Data Personal"
        self.generalPicker.delegate = self
        self.generalPicker.dataSource = self
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.datePicker.maximumDate = Date()
        pickerToolBar = UIToolbar()
        pickerToolBar.isTranslucent = true
        pickerToolBar.sizeToFit()
        pickerToolBar.tintColor = Colors.red
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(pickerDoneBtnPressed))
        let editButton = UIBarButtonItem(title: "Ubah", style: .plain, target: self, action: #selector(editBtnPressed))
        pickerToolBar.setItems([flexibleSpace, doneButton], animated: false)
        self.view.backgroundColor = Colors.backgroundView
        loadFormTable()
        navigationItem.rightBarButtonItem = editButton
        let buttonCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 8)) as! ButtonTableViewCell
        buttonCell.buttonOutlet.backgroundColor =  Colors.gray_disabled
        buttonCell.buttonOutlet.isEnabled = false
    }
    
    @objc func editBtnPressed(){
        if editMode == false{
            editMode = true
            for section in 0...5 {
                let cell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: section)) as! FormTableViewCell
                cell.clearBtn.isEnabled = true
                cell.clearBtn.fadeIn()
                cell.infoButton.moveInfoButtonWhenClearBtnAppears()
                cell.formTextField.isEnabled = false
            }
            navigationItem.rightBarButtonItem?.title = "Selesai"
        }
        else{
            editMode = false
            for section in 0...4 {
                let cell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: section)) as! FormTableViewCell
                cell.clearBtn.fadeOut()
                cell.clearBtn.isEnabled = false
                cell.formTextField.defaultPlaceholder()
                cell.formTextField.isEnabled = true
            }
            let codeReferral = formTableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! FormTableViewCell
            codeReferral.clearBtn.fadeOut()
            codeReferral.infoButton.moveInfoButtonWhenClearBtnMoveOut()
            codeReferral.formTextField.isEnabled = true
            codeReferral.formTextField.defaultPlaceholder()
            guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? ErrorMessageTableViewCell else {fatalError()}
            errorCell.errorMsg.isHidden = true
            navigationItem.rightBarButtonItem?.title = "Ubah"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome"{
            if let destination = segue.destination as? MainViewController {
                if rootViewController is FindController {
                    destination.selectedIndex = 0
                }
                else if rootViewController is DonateController {
                    destination.selectedIndex = 1
                }
                else if rootViewController is InboxController {
                    destination.selectedIndex = 2
                }
                else if rootViewController is DiscoverController {
                    destination.selectedIndex = 3
                }
            }
        }
    }
    
    func checkLocation(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    //function for getting region
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
          CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
              guard let placemark = placemark, error == nil else {
                  completion(nil, error)
                  return
              }
              completion(placemark, nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
           let location = locations.last!
           //locationManager stops updating location
           locationManager.stopUpdatingLocation()
        
           //get recordName from userdefaults
           guard let recordName = UserDefaults.standard.value(forKey: "currentUser") as? String else{
               return
           }
           let recordId = CKRecord.ID(recordName: recordName)
           
           var package : [String:Any]=[:]
           
           geocode(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (placemarks, error) in
           if error != nil {
              print("failed")
           }
           else {
             print("placemark not nil")
             guard
                 let placemark = placemarks else{fatalError()}
               if placemark.count > 0 {
                 DispatchQueue.main.async {
                     let placemark = placemarks?[0]
                     let province = placemark?.administrativeArea!
                   //Saving to user defaults
                   UserDefaults.standard.set(province,forKey: "province")
                   package = ["location": location, "province": province]
                    print(UserDefaults.standard.string(forKey: "province"))
                   // saving your CLLocation object to CloudKit
                   Helper.updateToDatabase(keyValuePair: package, recordID: recordId)
                 }
               }
             }
           }
        
           // saving to UserDefaults dalam bentuk NSData
           let locationData = NSKeyedArchiver.archivedData(withRootObject: location)
           UserDefaults.standard.set(locationData, forKey: "locationData")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBar(show: false)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = false
      self.navigationController?.navigationBar.isHidden = false
    }
    
    func saveToUserDefaults(userModel:UserModel?) {
        UserDefaults.standard.set(userModel?.email, forKey: "email")
        UserDefaults.standard.set(userModel?.password, forKey: "password")
        UserDefaults.standard.set(userModel?.name, forKey: "name")
        UserDefaults.standard.set(userModel?.bloodType.rawValue, forKey: "blood_type")
        UserDefaults.standard.set(userModel?.birthdate, forKey: "birth_date")
        UserDefaults.standard.set(userModel?.gender.rawValue, forKey: "gender")
        UserDefaults.standard.set(userModel?.isVerified, forKey: "isVerified")
        UserDefaults.standard.set(userModel?.lastDonor, forKey: "last_donor")
        UserDefaults.standard.set(userModel?.statusDonor, forKey: "donor_status")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setTabBar(show: true)
        guard
         let fullNameCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell,
         let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FormTableViewCell,
         let birthDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FormTableViewCell,
            let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? FormTableViewCell else{return}
         guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? ErrorMessageTableViewCell else {fatalError()}
        
        DispatchQueue.main.async {
              fullNameCell.formTextField.defaultPlaceholder()
              genderCell.formTextField.defaultPlaceholder()
              birthDateCell.formTextField.defaultPlaceholder()
              bloodTypeCell.formTextField.defaultPlaceholder()
              self.navigationController?.navigationBar.isHidden = true
              errorCell.errorMsg.isHidden = true
              self.removeSpinner()
        }
    }
    
    private func setTabBar(show: Bool){
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
  
  @objc func pickerDoneBtnPressed() {
      self.formTableView.reloadData()
      closePickerView()
  }
  
  func closePickerView() {
      view.endEditing(true)
      for textField in self.view.subviews where textField is UITextField {
          textField.resignFirstResponder()
      }
      view.gestureRecognizers?.removeLast()
  }
  
  
  @objc func dateChanged (datePicker : UIDatePicker, activeTF : UITextField) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd MMM y"
      guard
      let birthDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FormTableViewCell,
        let lastDonorDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? FormTableViewCell else {return}
    
      if birthDateCell.formTextField.isFirstResponder {
        self.activeTextfield = birthDateCell.formTextField
        birthDateCell.formTextField.text = dateFormatter.string(from: datePicker.date)
        self.detailUserCredentials["birthdate"] = birthDateCell.formTextField.text
      }
      if lastDonorDateCell.formTextField.isFirstResponder {
        self.activeTextfield = lastDonorDateCell.formTextField
        lastDonorDateCell.formTextField.text = dateFormatter.string(from: datePicker.date)
        self.detailUserCredentials["lastdonor"] = lastDonorDateCell.formTextField.text
      }
  }
    
    func loadFormTable(){
           formTableView.delegate = self
           formTableView.dataSource = self
           formTableView.register(UINib(nibName: "FormCustomCell", bundle: nil), forCellReuseIdentifier: "formCell")
           formTableView.register(UINib(nibName: "AgreementViewCell", bundle: nil), forCellReuseIdentifier: "agreementCell")
           formTableView.register(UINib(nibName: "ButtonViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
           formTableView.register(UINib(nibName: "ErrorMessageViewCell", bundle: nil), forCellReuseIdentifier: "errorMsgCell")
           formTableView.tableFooterView = UIView()
           formTableView.showsVerticalScrollIndicator = false
    }
    
}

extension RegisterDetailController: UITextFieldDelegate{
  func textFieldDidBeginEditing(_ textField: UITextField) {
    DispatchQueue.main.async {
        self.generalPicker.reloadAllComponents()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    DispatchQueue.main.async {
        self.view.endEditing(true)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    DispatchQueue.main.async {
        textField.resignFirstResponder()
    }
    return true
  }
}
