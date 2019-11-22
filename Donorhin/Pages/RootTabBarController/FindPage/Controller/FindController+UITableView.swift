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
        
        let height : CGFloat = 160
        
        return height
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
            cell?.date.text = "\(String(describing: data.date!))"
            cell?.status.text = data.status
            cell?.buttonCallOutlet.phoneNumber = data.phoneNumber
            
            cell?.buttonCallOutlet.setTitle("Call PMI Pendonor", for: .normal)
            cell?.buttonCallOutlet.isHidden = false
            cell?.buttonCallOutlet.addTarget(self, action: #selector(callButton(sender:)), for: .touchUpInside)
            
        }
        
        else {
        
            guard let data = bloodRequestHistory?[indexPath.row] else {fatalError()}
            
            cell?.title.text = data.name
            cell?.address.text = data.address
            cell?.date.text = "\(String(describing: data.date!))"
            cell?.status.text = data.status
            
            cell?.buttonCallOutlet.isHidden = true
        }
        
        cell?.backgroundColor = UIColor.clear
        
        // MARK : -Ini buat bikin kotak ditiap cellnya dan kasih space antara cell
        let backgroundViewCell : UIView = UIView(frame: CGRect(x: 0, y: 10, width:  self.tableView.frame.size.width, height: 150))
        
        backgroundViewCell.layer.backgroundColor = UIColor.white.cgColor
        backgroundViewCell.layer.masksToBounds = false
        backgroundViewCell.layer.cornerRadius = 10
        cell!.contentView.addSubview(backgroundViewCell)
        cell!.contentView.sendSubviewToBack(backgroundViewCell)
        
        if cell!.isSelected {
            backgroundViewCell.layer.backgroundColor = UIColor.gray.cgColor
        }
        else if !cell!.isSelected{
            backgroundViewCell.layer.backgroundColor = UIColor.white.cgColor
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if findBloodSegmentedControl.selectedSegmentIndex == 0 {
            guard let data = bloodRequestCurrent?[indexPath.row] else {fatalError()}
            navBarTitle = data.name
        }
        
        else {
            guard let data = bloodRequestHistory?[indexPath.row] else {fatalError()}
            navBarTitle = data.name
        }
        
        performSegue(withIdentifier: "moveToTracker", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
