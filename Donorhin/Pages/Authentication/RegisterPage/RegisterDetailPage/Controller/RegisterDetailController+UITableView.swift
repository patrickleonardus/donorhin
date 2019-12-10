//
//  RegisterDetailController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension RegisterDetailController : UITableViewDelegate{
    
}

extension RegisterDetailController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 6{
            return 45
        }
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 17
        if section == 6 || section == 7 {
            return 0
        }
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < formItems!.count {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath) as? FormTableViewCell
            //masukin datanya
            guard let data = formItems?[indexPath.section] else {fatalError()}
            
            cell?.formTextField.placeholder = data.placeholder
            cell?.delegate = self
            cell?.formTextField.delegate = self
            cell?.infoButton.isHidden = true
            cell?.iconImageView.image = UIImage(named: data.img!)
            cell?.formTextField.addDoneButtonOnKeyboard()
          if indexPath.section == 1 {
              cell?.formTextField.inputView = self.generalPicker
              cell?.formTextField.inputAccessoryView = self.pickerToolBar
          }
          if indexPath.section == 2 {
            cell?.formTextField.inputView = self.datePicker
            cell?.formTextField.inputAccessoryView = self.pickerToolBar
          }
          if indexPath.section == 3 {
            cell?.formTextField.inputView = self.generalPicker
            cell?.formTextField.inputAccessoryView = self.pickerToolBar
          }
          if indexPath.section == 4 {
            cell?.formTextField.inputView = self.datePicker
            cell?.formTextField.inputAccessoryView = self.pickerToolBar
          }
          if indexPath.section == 5{
            cell?.infoButton.isHidden = false
          }
            cell?.backgroundColor = UIColor.white
            cell?.layer.cornerRadius = 10
            return cell!
        }
        else if indexPath.section == 6{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "errorMsgCell", for: indexPath) as? ErrorMessageTableViewCell
            cell?.errorMsg.isHidden = true
            return cell!
        }
                  
        else if indexPath.section == 7{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "agreementCell", for: indexPath) as? AgreementTableViewCell
                cell?.delegate = self
                return cell!
            }
        
            else if indexPath.section == 8{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonTableViewCell
                  cell?.buttonOutlet.layer.cornerRadius = 10
                  cell?.buttonOutlet.setTitle("Daftar", for: .normal)
                  cell?.delegate = self
                return cell!
              }
        return UITableViewCell()
    }
}


extension RegisterDetailController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FormTableViewCell
    let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! FormTableViewCell
    if genderCell.formTextField.isFirstResponder {
      return self.gender.count
    }
    else if bloodTypeCell.formTextField.isFirstResponder {
      return self.bloodType.count
    }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FormTableViewCell
    let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! FormTableViewCell
    if genderCell.formTextField.isFirstResponder {
      genderCell.formTextField.text = self.gender[row]
      return self.gender[row]
    }
    else if bloodTypeCell.formTextField.isFirstResponder {
      bloodTypeCell.formTextField.text = self.bloodType[row]
      return self.bloodType[row]
    }
    return ""
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let genderCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FormTableViewCell
    let bloodTypeCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! FormTableViewCell
    if genderCell.formTextField.isFirstResponder {
      genderCell.formTextField.text = self.gender[row]
      self.detailUserCredentials["gender"] = self.gender[row]
    }
    else if bloodTypeCell.formTextField.isFirstResponder {
      bloodTypeCell.formTextField.text = self.bloodType[row]
      self.detailUserCredentials["bloodType"] = self.bloodType[row]
    }
  }
}


extension RegisterDetailController: AgreementDelegate {
    func checkAgreementCheckBox(_ isCheck: Bool) {
    let buttonCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 8)) as! ButtonTableViewCell
    let nameCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTableViewCell
    
        if isCheck {
            if self.detailUserCredentials["gender"] != "" || self.detailUserCredentials["bloodType"] != "" || self.detailUserCredentials["name"] != "" || self.detailUserCredentials["birthdate"] != "" || self.detailUserCredentials["lastdonor"] != "" || nameCell.formTextField!.text != "" {
                buttonCell.buttonOutlet.backgroundColor =  Colors.red
                buttonCell.buttonOutlet.isEnabled = true
            }
        }
        else {
          buttonCell.buttonOutlet.backgroundColor =  Colors.gray_disabled
          buttonCell.buttonOutlet.isEnabled = false
        }
    
    }
  
  func goToPrivacy() {
    performSegue(withIdentifier: "GoToAgreement", sender: nil)
  }
}
