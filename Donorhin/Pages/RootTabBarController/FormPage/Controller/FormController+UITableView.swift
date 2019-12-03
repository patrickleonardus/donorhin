//
//  FormController+UITableView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FormController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextCellFirstCell") as! LabelAndTextCell
      cell.delegate = self
      
      guard let formQuestion = formQuestionData?[indexPath.row] else {fatalError()}
      guard let formPlaceholder = formPlaceholderData?[indexPath.row] else {fatalError()}
      
      cell.firstLabel.text = formQuestion.questionName
      cell.firstTextField.placeholder = formPlaceholder.placeholder
      cell.firstTextField.inputAccessoryView = pickerToolbar
      
      cell.personalTableViewSection = indexPath.section
      cell.personalTableViewRow = indexPath.row
      
      if indexPath.row == 0 {
        cell.firstTextField.textContentType = .name
      }
      
      else if indexPath.row == 2 {
        let picker = UIPickerView()
        picker.delegate = self
        cell.firstTextField.inputView = picker
      }
        
      else if indexPath.row == 3 {
        cell.firstTextField.addTarget(self, action: #selector(showDatePicker(sender:)), for: .editingDidBegin)
      }
      
      else if indexPath.row == 4 {
        cell.firstTextField.keyboardType = .numberPad
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
      }
      
      return cell
    }
}
