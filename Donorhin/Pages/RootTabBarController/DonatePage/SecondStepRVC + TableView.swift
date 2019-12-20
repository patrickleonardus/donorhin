//
//  SecondStepRVC + TableView.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 17/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

//MARK:- Setting up table view
extension SecondStepRequestViewController : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 2
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 51
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LabelWithTextFieldTableViewCell
    
    if indexPath.row == 0 {
      cell.label.text = "Tanggal donor"
      cell.accessoryView = UIImageView(image: UIImage(named: "calendar20"))
      cell.textField.delegate = self
    } else {
      cell.label.text = "Lokasi UTD Mendonor"
      cell.textField.isHidden = true
      cell.textField.isUserInteractionEnabled = false
      cell.accessoryType = .disclosureIndicator
    }
    
    return cell
//      let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
//      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if  indexPath.row == 0 {
        
//        cell.accessoryView = nil
      }  else if indexPath.row == 1 {
         performSegue(withIdentifier: "showHospitalList", sender: self)
      }
    tableView.deselectRow(at: indexPath, animated: false)
   }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination as! HospitalController
    destination.hospitalDelegate = self
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! LabelWithTextFieldTableViewCell
    cell.accessoryView = nil
    self.buttonBersedia.isEnabled = isFilled
  }
  
  
}

//MARK:- Extension DelegateUTD
extension SecondStepRequestViewController:HospitalDelegate {
  func selectedHospital(hospital: HospitalModel) {
    self.chosenHospital = hospital
    let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? LabelWithTextFieldTableViewCell
    cell?.accessoryType = .none
    cell?.textField.isHidden = false
    cell?.textField.text = chosenHospital?.name

    cell?.isSelected = false
    self.buttonBersedia.isEnabled = isFilled
  }
}



