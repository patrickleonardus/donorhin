//
//  AddEventController+UITableView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension AddEventController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0
        
        if indexPath.section < 3 {
            height = 90
        }
        else {
            height = 150
        }
        
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        if section == 0 {
            numberOfRows = 3
        }
        else if section == 1 {
            numberOfRows = 3
        }
        else if section == 2 {
            numberOfRows = 2
        }
        else if section == 3{
            numberOfRows = 1
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height : CGFloat = 0
        
        if section < 3 {
            height = 60
        }
            
        else {
            height = 10
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 60))
        headerView.backgroundColor = Colors.backgroundView
        
        if section < 3 {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
            label.text = titleForHeaderInSection[section]
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = Colors.gray
            
            let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.5))
            separatorView.backgroundColor = Colors.gray_line
            
            headerView.addSubview(label)
            headerView.addSubview(separatorView)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.bottomAnchor.constraint(equalTo: separatorView.topAnchor).isActive = true
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor,constant: 20).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            separatorView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            separatorView.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //MARK: - Setup cellnya
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descEvent") as! LabelAndTextFieldCell
            cell.delegate = self
            
            guard let titleData = cellName?[indexPath.row] else {fatalError()}
            guard let placeholderData = cellPlaceholder?[indexPath.row] else {fatalError()}
            
            if indexPath.row == 0 {
                
                if titleEvent == nil {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.placeholder = placeholderData.placeholder
                }
                
                else  {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.text = titleEvent
                }
                
            }
                
            else if indexPath.row == 1 {
                
                if descEvent == nil {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.placeholder = placeholderData.placeholder
                }
                    
                else  {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.text = descEvent
                }
                
            }
            
            else if indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "pickPictureCell") as! PickPictureCell
                
                cell.addPictureButton.addTarget(self, action: #selector(pickPicture), for: .touchUpInside)
                
                cell.title.text = titleData.name
                
                if fixedImage != nil {
                    cell.imageEvent.image = fixedImage
                }
                
                return cell
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descEvent") as! LabelAndTextFieldCell
            cell.delegate = self
            
            guard let titleData = cellName?[indexPath.row + 3] else {fatalError()}
            guard let placeholderData = cellPlaceholder?[indexPath.row + 2] else {fatalError()}
          
            if indexPath.row == 0 {
                
                if locEvent == nil {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.placeholder = placeholderData.placeholder
                }
                    
                else  {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.text = locEvent
                }
                
                cell.answer.removeTarget(self, action: #selector(showDatePickerStart(sender:)), for: .editingDidBegin)
                cell.answer.removeTarget(self, action: #selector(showDatePickerEnd(sender:)), for: .editingDidBegin)
                
            }
            
            else if indexPath.row == 1 {
                
                if startEvent == nil {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.placeholder = placeholderData.placeholder
                }
                    
                else  {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.text = startEvent
                }
                
                cell.answer.addTarget(self, action: #selector(showDatePickerStart(sender:)), for: .editingDidBegin)
                
            }
            else if indexPath.row == 2 {
                
                if endEvent == nil {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.placeholder = placeholderData.placeholder
                }
                    
                else  {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.text = endEvent
                }
                
                cell.answer.addTarget(self, action: #selector(showDatePickerEnd(sender:)), for: .editingDidBegin)
            }
            
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descEvent") as! LabelAndTextFieldCell
            cell.delegate = self
            
            guard let titleData = cellName?[indexPath.row + 6] else {fatalError()}
            guard let placeholderData = cellPlaceholder?[indexPath.row + 5] else {fatalError()}
           
            if indexPath.row == 0 {
                
                if nameEvent == nil {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.placeholder = placeholderData.placeholder
                }
                    
                else  {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.text = nameEvent
                }
                
            }
            
            else if indexPath.row == 1 {
                
                if phoneEvent == nil {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.placeholder = placeholderData.placeholder
                }
                    
                else  {
                    cell.tableViewRow = indexPath.row
                    cell.tableViewSection = indexPath.section
                    cell.name.text = titleData.name
                    cell.answer.text = phoneEvent
                }
                
            }
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkEvent") as! CheckboxAgreementCell
            cell.delegate = self
            return cell
        }
        
        
        return UITableViewCell()
    }
    
}

