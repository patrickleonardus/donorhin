//
//  RegisterController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
extension RegisterController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 33
        }
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
        if section > 2{
            return 0
        }
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.section < 3 {
          let cell  = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath) as? FormTableViewCell
          guard let data = formItems?[indexPath.section] else {fatalError()}
          cell?.infoButton.isHidden = true
          cell?.clearBtn.isHidden = true
          cell?.formTextField.placeholder = data.placeholder
          cell?.iconImageView.image = UIImage(named: data.img!)
          cell?.formTextField.addDoneButtonOnKeyboard()
          if indexPath.section == 1 || indexPath.section == 2  {
             cell?.formTextField.isSecureTextEntry = true
          }
          cell?.backgroundColor = UIColor.white
          cell?.layer.cornerRadius = 10
          cell?.delegate = self
          return cell!
        }
            
        else if indexPath.section == 3 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "errorMsgCell", for: indexPath) as? ErrorMessageTableViewCell
            cell?.errorMsg.isHidden = true
            return cell!
        }
            
        else if indexPath.section == 4 {
          let cell  = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonTableViewCell
              cell?.buttonOutlet.layer.cornerRadius = 10
              cell?.buttonOutlet.setTitle("Lanjut", for: .normal)
              cell?.delegate = self
          return cell!
        }
        
        return UITableViewCell()
    }
}
