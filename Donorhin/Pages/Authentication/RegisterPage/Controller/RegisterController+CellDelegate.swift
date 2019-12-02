//
//  RegisterController+CellDelegate.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension RegisterController : FormCellDelegate{
    
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

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height

         if activeCell != nil{
            if !aRect.contains(self.activeCell!.frame.origin) {
                self.formTableView.scrollRectToVisible(activeCell!.frame, animated: true)
            }
         }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.formTableView.contentInset = contentInsets
        self.formTableView.scrollIndicatorInsets = contentInsets
    }
    
  //MARK: - action when next button tapped
  
  func buttonDidTap() {
    self.showSpinner(onView: self.view)
    let emailCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FormTableViewCell
    let passCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! FormTableViewCell
    let confirmPassCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! FormTableViewCell
    guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ErrorMessageTableViewCell else {fatalError()}
    
    if self.validationCredential(email: emailCell.formTextField.text!, password: passCell.formTextField.text!, confirmPassword: confirmPassCell.formTextField.text!) == true {
      self.checkExistUserEmail(email: emailCell.formTextField.text!) { (bool) in
        if bool == false{
          DispatchQueue.main.async {
            self.removeSpinner()
            errorCell.errorMsg.isHidden = false
            errorCell.errorMsg.text = "*Email sudah pernah terdaftar, coba email yang lain"
            emailCell.shake()
            emailCell.formTextField.redPlaceholder()
          }
        }
        else{
          DispatchQueue.main.async {
            self.removeSpinner()
            self.userCredentials = ["email":emailCell.formTextField.text!,"password":passCell.formTextField.text!]
            self.performSegue(withIdentifier: "goToPersonalData", sender: nil)
            errorCell.errorMsg.isHidden = true
          }
        }
      }
    }
  }
}
