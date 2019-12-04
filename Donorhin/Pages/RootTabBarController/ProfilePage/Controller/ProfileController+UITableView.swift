//
//  ProfileController+UITableView.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension ProfileController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = 0
        
        if indexPath.section == 0 {
            height = 200
        }
            
        else if indexPath.section == 1 {
            height = 70
        }
            
        else if indexPath.section == 2 {
            height = 70
        }
        
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        if section == 0 {
            numberOfRows = 1
        }
            
        else if section == 1 {
            numberOfRows = 4
        }
            
        else if section  == 2 {
            numberOfRows = 1
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        

        var date: Date? = Date()

        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? FirstCell
            
            cell?.nameProfile.text = UserDefaults.standard.string(forKey: "name")
            cell?.emailProfile.text = UserDefaults.standard.string(forKey: "email")
            cell?.imageProfile.image = UIImage(named: "icon_profile")
            
            print(user?.profileName)
            
            
            return cell!
        }
            
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as? SecondCell
            cell?.profileTextField.borderStyle = .none
            cell?.profileTextField.addDoneButtonOnKeyboard()
            if indexPath.row == 0 {
                cell?.imageCell.image = UIImage(named: "gender_profile")
                var gender : String = "Laki-Laki"
                
                switch UserDefaults.standard.integer(forKey: "gender"){
                case 0: gender = "Perempuan"
                    break
                case 1: gender = "Laki-Laki"
                    break
                default: break
                }
                cell?.profileTextField.text = gender
                cell?.profileTextField.inputView = self.customPicker
                cell?.profileTextField.inputAccessoryView = self.pickerToolBar
            }
                
            else if indexPath.row == 1 {
                cell?.imageCell.image = UIImage(named: "birthday_profile")
                if user?.profileBirthday == nil{
                cell?.profileTextField.text = "-"
                }
                else{
//                 cell?.profileTextField.text = dateFormatter.string(from: user!.profileBirthday!)
                cell?.profileTextField.text = dateFormatter.string(from: UserDefaults.standard.object(forKey: "birth_date")! as! Date)
                cell?.profileTextField.inputView = self.datePicker
                cell?.profileTextField.inputAccessoryView = self.pickerToolBar
                }
            }
                
            else if indexPath.row == 2 {
                cell?.imageCell.image = UIImage(named: "bloodtype_profile")
                cell?.profileTextField.text = UserDefaults.standard.string(forKey: "blood_type")
                cell?.profileTextField.inputView = self.customPicker
                cell?.profileTextField.inputAccessoryView = self.pickerToolBar
            }
                
            else if indexPath.row == 3 {
                cell?.imageCell.image = UIImage(named: "lastdonor_profile")

                cell?.profileTextField.text = dateFormatter.string(from: UserDefaults.standard.object(forKey: "last_donor") as? Date ?? Date())
                cell?.profileTextField.inputView = self.datePicker
                cell?.profileTextField.inputAccessoryView = self.pickerToolBar
            }
            
            return cell!
        }
            
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell", for: indexPath) as? ThirdCell
            
            cell?.logoutOutlet.setTitle("Logout", for: .normal)
            cell?.logoutOutlet.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
            
            return cell!
        }
        
        return UITableViewCell()
    }
    
}

extension ProfileController: UIPickerViewDataSource, UIPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    guard let genderCell = tableView.cellForRow(at: IndexPath(row:0, section: 1)) as? SecondCell else {fatalError()}
    guard let bloodTypeCell = self.tableView.cellForRow(at: IndexPath(row:2, section: 1)) as? SecondCell else{fatalError()}
    if genderCell.profileTextField.isFirstResponder {
      return self.gender.count
    }
    else if bloodTypeCell.profileTextField.isFirstResponder {
      return self.bloodType.count
    }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let genderCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SecondCell
    let bloodTypeCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! SecondCell
    if genderCell.profileTextField.isFirstResponder {
      genderCell.profileTextField.text = self.gender[row]
      return self.gender[row]
    }
    else if bloodTypeCell.profileTextField.isFirstResponder {
      bloodTypeCell.profileTextField.text = self.bloodType[row]
      return self.bloodType[row]
    }
    return ""
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let genderCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SecondCell
    let bloodTypeCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! SecondCell
    if genderCell.profileTextField.isFirstResponder {
      genderCell.profileTextField.text = self.gender[row]

    }
    else if bloodTypeCell.profileTextField.isFirstResponder {
      bloodTypeCell.profileTextField.text = self.bloodType[row]

    }
  }
}
