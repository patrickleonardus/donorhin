//
//  RegisterDetailController+CellDelegate.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
extension RegisterDetailController : FormCellDelegate {
    func clearTextField(cell: FormTableViewCell) {
        guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? ErrorMessageTableViewCell else {fatalError()}
        if cell.formTextField.text == ""{
            cell.shake()
            cell.formTextField.redPlaceholder()
            errorCell.errorMsg.isHidden = false
            errorCell.errorMsg.text = "*Tidak bisa menghapus form yang belum diisi"
        }
        else{
        cell.formTextField.defaultPlaceholder()
        cell.formTextField.text = ""
        }
    }
    
    func textFieldDidBeginEditing(cell: FormTableViewCell) {
        self.activeCell = cell
    }
    
    func textFieldDidEndEditing() {
        self.activeCell = nil
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)

        self.formTableView.contentInset = contentInsets
        self.formTableView.scrollIndicatorInsets = contentInsets

        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        if activeCell != nil{
            let pointInTable = activeCell!.frame.origin
            let rectInTable = activeCell!.frame

            if !aRect.contains(pointInTable) {
            self.formTableView.scrollRectToVisible(rectInTable, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.formTableView.contentInset = contentInsets
        self.formTableView.scrollIndicatorInsets = contentInsets
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Gagal Masuk Ke Akun", message: "Harap mengecek jaringan anda dan coba beberapa saat lagi", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oke", style: UIAlertAction.Style.default) { UIAlertAction in
            self.performSegue(withIdentifier: "goToAuth", sender: self)
           })
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginAccount() {
        DataFetcher().getUserDataByEmail(email: (self.userCredentials["email"]!), password: (self.userCredentials["password"]!)){ (userModel) in
            if userModel != nil {
                DispatchQueue.main.async{
                    print("Processing...")
                    self.checkLocation()
                    self.saveToUserDefaults(userModel: userModel)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6){
                      print("Data saved to user default...")
                      self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.showErrorAlert()
                    print("Error")
                }
            }
        }
    }
    
    func showContinueActionAlert(){
        let alert = UIAlertController(title: "Pendaftaran Berhasil", message: "Harap pilih lanjut untuk masuk ke akun", preferredStyle: UIAlertController.Style.alert)
        let continue_action = UIAlertAction(title: "Lanjut", style: UIAlertAction.Style.default) { UIAlertAction in
            self.showSpinner(onView: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self.loginAccount()
            }
        }
        alert.addAction(continue_action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func buttonDidTap() {
      guard
      let fullNameCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell,
      let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FormTableViewCell,
      let birthDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FormTableViewCell,
      let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? FormTableViewCell,
      let lastDonoCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? FormTableViewCell,
      let referralCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? FormTableViewCell else{ fatalError("found nil") }
      guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? ErrorMessageTableViewCell else {fatalError()}
        print("button tapped")
        
        self.validateUserDetail(fullName: fullNameCell.formTextField.text!, gender: genderCell.formTextField.text!, birthDate: birthDateCell.formTextField.text!, bloodType: bloodTypeCell.formTextField.text!, referralCode : referralCell.formTextField.text!) { (isSuccess) in
            if isSuccess {
              DispatchQueue.main.async {
                self.showSpinner(onView: self.view)
                let encryptedPassword : String = PasswordCryptor().encryptMessage(password: self.userCredentials["password"]!)
                print(encryptedPassword)
                let record = CKRecord(recordType: "Account")
                record.setValue(bloodTypeCell.formTextField.text!, forKey: "blood_type")
                record.setValue(0, forKey: "donor_status")
                record.setValue(self.userCredentials["email"], forKey: "email")
                record.setValue(encryptedPassword, forKey: "password")
                record.setValue(fullNameCell.formTextField.text!, forKey: "name")
                record.setValue(self.checkGender(genderCell.formTextField.text!), forKey: "gender")
                record.setValue(self.convertDateFromString(birthDateCell.formTextField.text!), forKey: "birth_date")
                if lastDonoCell.formTextField.text! != "" {
                  record.setValue(self.convertDateFromString(lastDonoCell.formTextField.text!), forKey: "last_donor")
                }
                if referralCell.formTextField.text! != "" {
                  let referral_code = referralCell.formTextField.text
                  let query = CKQuery(recordType: "Code", predicate: NSPredicate(format: "referral_code = %@", referral_code!))
                    
                  self.checkingReferralCode(query){ (result) in
                    DispatchQueue.main.async {
                        guard var quota : Int = result!.value(forKey: "quota") as? Int else {fatalError()}
                        let recordID : CKRecord.ID = result!.recordID
                        quota -= 1
                        let package : [String:Int] = ["quota":quota]
                        Helper.updateToDatabase(keyValuePair: package, recordID: recordID)
                        print("Successfully claiming referral code!")
                        }
                    }
                   record.setValue(1, forKey: "isVerified")
                }
                else {
                  record.setValue(0, forKey: "isVerified")
                }
                  
                Helper.saveData(record) {[weak self] (isSuccess) in
                  if isSuccess {
                      DispatchQueue.main.async {
                          self?.removeSpinner()
                          self?.showContinueActionAlert()
                      }
                  }
                  else {
                      DispatchQueue.main.async {
                          self?.removeSpinner()
                          errorCell.errorMsg.isHidden = false
                          errorCell.errorMsg.text = "*Pendaftaran belum berhasil, silahkan coba beberapa saat lagi"
                    }
                  }
                }
              }
            }
          }
    }
  
    func checkingReferralCode(_ query: CKQuery, completionHandler: @escaping ((CKRecord?) -> Void)) {
        var record : CKRecord? = nil
        Helper.getAllData(query){ (results) in
            if let results = results {
                DispatchQueue.main.async {
                    for result in results {
                        record = result
                    }
                    if record != nil{
                        guard let quota : Int = record?.value(forKey: "quota") as? Int else{
                            fatalError()
                        }
                        if quota > 0 {
                            completionHandler(record)
                        }
                        else{
                            completionHandler(nil)
                        }
                    }
                    else {
                        completionHandler(nil)
                    }
                }
            }else{
                completionHandler(nil)
            }
        }
    }
    
    func validateUserDetail(fullName: String, gender: String, birthDate: String, bloodType: String, referralCode : String, completion: @escaping (Bool) -> ()) {
    guard
    let fullNameCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell,
    let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FormTableViewCell,
    let birthDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FormTableViewCell,
    let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? FormTableViewCell,
    let referralCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? FormTableViewCell else{ fatalError() }
    guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? ErrorMessageTableViewCell else {fatalError()}
    
    if fullName == "" || gender == "" || birthDate == "" || bloodType == ""{
        DispatchQueue.main.async {
            fullNameCell.shake()
            genderCell.shake()
            birthDateCell.shake()
            bloodTypeCell.shake()

            fullNameCell.formTextField.redPlaceholder()
            genderCell.formTextField.redPlaceholder()
            birthDateCell.formTextField.redPlaceholder()
            bloodTypeCell.formTextField.redPlaceholder()
            
            errorCell.errorMsg.isHidden = false
            errorCell.errorMsg.text = "*Pastikan seluruh form telah terisi"
        }
        completion(false)
    }
    else if referralCode != "" {
      let query = CKQuery(recordType: "Code", predicate: NSPredicate(format: "referral_code = %@", referralCode))
        checkingReferralCode(query){ (result) in
            if result != nil{
                DispatchQueue.main.async {
                    errorCell.errorMsg.isHidden = true
                }
                completion(true)
            }
            else{
                DispatchQueue.main.async {
                    errorCell.errorMsg.isHidden = false
                    errorCell.errorMsg.text = "*Kode Referral tidak valid"
                    referralCell.shake()
                }
                completion(false)
            }
        }
    }
    else {
        errorCell.errorMsg.isHidden = true
        completion(true)
    }
  }
  
  func checkGender(_ gender: String) -> Int {
    switch gender {
    case "Pria":
      return 1
    case "Wanita":
      return 0
    default:
      return 1
    }
  }
  
  func convertDateFromString(_ date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM yyyy"
    let newdate = dateFormatter.date(from: date)!
    return newdate
  }
    
    func infoButtonDidTap(){
        performSegue(withIdentifier: "goToCoordinatorInfo", sender: nil)
    }
    
}
