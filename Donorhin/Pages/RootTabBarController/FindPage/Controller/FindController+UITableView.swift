//
//  FindController+UITableViewDelegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FindController: UITableViewDelegate {
    
}


extension FindController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var totalData = 0
        
        if findBloodSegmentedControl.selectedSegmentIndex == 0 {
            if let data = bloodRequestCurrent?.count {
                totalData = data
            }
        }
        
        else {
            if let data = bloodRequestHistory?.count {
                totalData = data
            }
        }
        
        return totalData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FindBloodCustomCell
        
        if findBloodSegmentedControl.selectedSegmentIndex == 0 {
            
            guard let data = bloodRequestCurrent?[indexPath.row] else {fatalError()}
            cell?.title.text = data.name
            cell?.address.text = data.address
            cell?.date.text = data.date
            cell?.status.text = data.status
            
            cell?.buttonCallOutlet.setTitle("Call PMI Pendonor", for: .normal)
            cell?.buttonCallOutlet.isHidden = false
            cell?.buttonCallOutlet.addTarget(self, action: #selector(callButton), for: .touchUpInside)
            
        }
        
        else {
        
            let data = bloodRequestHistory![indexPath.row]
            
            cell?.title.text = data.name
            cell?.address.text = data.address
            cell?.date.text = data.date
            cell?.status.text = data.status
            
            cell?.buttonCallOutlet.isHidden = true
        }
        
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell!
    }
    
    
}
