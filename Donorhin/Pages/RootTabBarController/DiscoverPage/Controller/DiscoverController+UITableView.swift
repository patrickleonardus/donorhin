//
//  DiscoverController+UITableView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension DiscoverController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = 0
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                height = 260
            }
        }
        
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
              height = 420
            }
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
       return self.sectionHeaderTitleArray[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let frame: CGRect = tableView.frame
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Int(frame.size.width), height: Int(frame.size.height)))
        headerView.backgroundColor = Colors.backgroundView
        
        let label : UILabel = UILabel(frame: CGRect(x: 20, y: 10, width: 150, height: 30))
        label.text = sectionHeaderTitleArray[section]
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 { 
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell
                cell.backgroundColor = Colors.backgroundView
                cell.moveToAddEventDelegate = self
                cell.moveToDetailEventDelegate = self
              cell.alertDelegate = self
                return cell
            }
        }
        
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoTableViewCell
                
                cell.delegate = self
                cell.tableViewInfo.layer.cornerRadius = 10
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
