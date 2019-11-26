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
extension RegisterDetailController : FormCellDelegate{
    
    func buttonDidTap() {
      
      let fullNameCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTableViewCell
      let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FormTableViewCell
      let birthDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! FormTableViewCell
      let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! FormTableViewCell
      let lastDonoCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! FormTableViewCell
      let referralCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! FormTableViewCell
      guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? ErrorMessageTableViewCell else {fatalError()}
      if self.validateUserDetail(fullName: fullNameCell.formTextField.text!, gender: genderCell.formTextField.text!, birthDate: birthDateCell.formTextField.text!, bloodType: bloodTypeCell.formTextField.text!) {
        self.showSpinner(onView: self.view)
        self.checkExistUserEmail(self.userCredentials["email"]!) { (isExist) in
          if !isExist {
            DispatchQueue.main.async {
              let record = CKRecord(recordType: "Account")
              record.setValue(bloodTypeCell.formTextField.text!, forKey: "blood_type")
              record.setValue(0, forKey: "donor_status")
              record.setValue(self.userCredentials["email"], forKey: "email")
              record.setValue(self.userCredentials["password"], forKey: "password")

              record.setValue(fullNameCell.formTextField.text!, forKey: "name")
              record.setValue(self.checkGender(genderCell.formTextField.text!), forKey: "gender")
              record.setValue(self.covertDateFromString(birthDateCell.formTextField.text!), forKey: "birth_date")
              if lastDonoCell.formTextField.text! != "" {
                record.setValue(self.covertDateFromString(lastDonoCell.formTextField.text!), forKey: "last_donor")
              }
              if referralCell.formTextField.text! != "" {
                record.setValue(1, forKey: "isVerified")
              }
              else {
                record.setValue(0, forKey: "isVerified")
              }
              Helper.saveData(record) {[weak self] (isSuccess) in
                if isSuccess {
                  DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "goToFind", sender: nil)
                    self?.removeSpinner()
                  }
                }
                else {
                  self?.removeSpinner()
//                  let alert = UIAlertController(title: "Peringatan", message: "Pendaftaran belum berhasil, silahkan coba beberapa saat lagi", preferredStyle: .alert)
//                  let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
//                  alert.addAction(action)
//                  self?.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.async {
                        errorCell.errorMsg.isHidden = false
                        errorCell.errorMsg.text = "*Pendaftaran belum berhasil, silahkan coba beberapa saat lagi"
                    }
                }
              }
            }
          }
          else {
            self.removeSpinner()
            DispatchQueue.main.async {
                errorCell.errorMsg.isHidden = false
                errorCell.errorMsg.text = "*Email sudah pernah terdaftar, coba email yang lain"
            }
//            let alert = UIAlertController(title: "Peringatan", message: "Email sudah pernah terdaftar, coba email yang lain", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
          }
        }
      }
    }
  
  func validateUserDetail(fullName: String, gender: String, birthDate: String, bloodType: String) -> Bool {
    let fullNameCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTableViewCell
    let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FormTableViewCell
    let birthDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! FormTableViewCell
    let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! FormTableViewCell
    let lastDonoCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! FormTableViewCell
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
            errorCell.errorMsg.text = "*Harap pastikan seluruh form sudah terisi"
        }
//      let alert = UIAlertController(title: "Peringatan", message: "Nama lengkap, jenis kelamin, tanggal lahir, dan golongan darah harus diisi", preferredStyle: .alert)
//      let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
//      alert.addAction(action)
//      self.present(alert, animated: true, completion: nil)
      return false
    }
    errorCell.errorMsg.isHidden = true
    return true
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
  
  func covertDateFromString(_ date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM yyyy"
    let newdate = dateFormatter.date(from: date)!
    return newdate
  }
  
  func checkExistUserEmail(_ email: String, completion: @escaping (Bool) -> Void) {
    let ckRecord = CKQuery(recordType: "Account", predicate: NSPredicate(format: "email = %@", email))
    self.database.perform(ckRecord, inZoneWith: .default) { (res, err) in
      if let result = res {
        if result.count > 0 {
          completion(true)
        }
        else {
          completion(false)
        }
      }else {
        completion(false)
      }
    }
  }
}
