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
        
        var numberOfSections : Int?
        
        switch tableView {
            
        case personalTableView:
            numberOfSections = 1
            break
            
            
        case detailTableView:
            numberOfSections = 2
            break
            
            
        default:
            numberOfSections = 0
            break
        }
        return numberOfSections!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRowsInSection : Int?
        
        switch tableView {
            
        case personalTableView:
            numberOfRowsInSection = 3
            break
            
            
        case detailTableView:
            
            if section == 0 {
                numberOfRowsInSection = 1
            }
            else if section == 1 {
                numberOfRowsInSection = 2
            }
            
            break
            
            
        default:
            numberOfRowsInSection = 0
            break
        }
        return numberOfRowsInSection!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case personalTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextCellFirstCell") as! LabelAndTextCell
            cell.delegate = self
            
            guard let formQuestion = formQuestionData?[indexPath.row] else {fatalError()}
            guard let formPlaceholder = formPlaceholderData?[indexPath.row] else {fatalError()}
            
            cell.firstLabel.text = formQuestion.questionName
            cell.firstTextField.placeholder = formPlaceholder.placeholder
            
            cell.personalTableViewSection = indexPath.section
            cell.personalTableViewRow = indexPath.row
            
            if indexPath.row == 2{
                
                let picker = UIPickerView()
                picker.delegate = self
                cell.firstTextField.inputView = picker
                cell.firstTextField.inputAccessoryView = pickerToolbar
                cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            }
            
            return cell
            
            
        case detailTableView:
            
           
            
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndSwitchCell") as! LabelAndSwitchCell
                
                guard let formQuestion = formQuestionData?[indexPath.row + 3] else {fatalError()}
                
                cell.labelText.text = formQuestion.questionName
                
                cell.delegate = self
                
                return cell
            }
            
            else if indexPath.section == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "labelAndTextCellSecondCell") as! LongLabelAndTextCell
                cell.delegate = self
                
                guard let formQuestion = formQuestionData?[indexPath.row + 4] else {fatalError()}
                guard let formPlaceholder = formPlaceholderData?[indexPath.row + 3] else {fatalError()}
                
                cell.secondLabel.text = formQuestion.questionName
                cell.secondTextField.placeholder = formPlaceholder.placeholder
                
                cell.detailTableViewSection = indexPath.section
                cell.detailTableViewRow = indexPath.row
                
                if indexPath.row == 0 {
                    cell.secondTextField.addTarget(self, action: #selector(showDatePicker(sender:)), for: .editingDidBegin)
                    cell.secondTextField.inputAccessoryView = pickerToolbar
                }
                
                else if indexPath.row == 1 {
                    cell.secondTextField.keyboardType = .numberPad
                    cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
                }
                
                return cell
            }
            
            break

        default:
            break
        }
        
        return UITableViewCell()
        
    }
    
    
}
