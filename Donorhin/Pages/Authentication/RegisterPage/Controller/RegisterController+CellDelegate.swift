//
//  RegisterController+CellDelegate.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension RegisterController : FormCellDelegate{
    func buttonDidTap() {
      let emailCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTableViewCell
      let passCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FormTableViewCell
      let comfirmPassCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! FormTableViewCell
      if self.validationCredential(email: emailCell.formTextField.text!, password: passCell.formTextField.text!, confirmPassword: comfirmPassCell.formTextField.text!) {
        self.userCredentials = ["email":emailCell.formTextField.text!,"password":passCell.formTextField.text!]
        performSegue(withIdentifier: "goToPersonalData", sender: nil)
      }
    }
}
