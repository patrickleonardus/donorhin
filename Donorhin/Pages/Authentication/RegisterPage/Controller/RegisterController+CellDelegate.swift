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
        guard let emailCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell else {return}
        guard let passCell = formTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? FormTableViewCell else {return}
        guard let comfirmPassCell = formTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? FormTableViewCell else {return}
        validationCredential(email: emailCell.formTextField.text!, password: passCell.formTextField.text!, confirmPassword: comfirmPassCell.formTextField.text)
    }
}
