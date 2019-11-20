//
//  LoginController+CellDelegate.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension LoginController : FormCellDelegate, CustomProtocol{
    func dismissed() {
        var vc : UIViewController?
        if #available(iOS 13.0, *) {
            vc = storyboard!.instantiateViewController(identifier: "authStoryboard") as! LoginController
        } else {
            // Fallback on earlier versions
        }
        guard let navigationController = self.navigationController else {return}
        navigationController.pushViewController(vc!, animated: true)
    }
    
    func buttonDidTap() {
        print("buttonDidTap")
        guard let emailCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell else {return}
        guard let passCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FormTableViewCell else {return}
        let email : String = String(emailCell.formTextField.text!)
        let password: String = String(passCell.formTextField.text!)
        validationCredential(email: email, password: password)
    }
    
}
