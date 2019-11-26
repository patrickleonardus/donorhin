//
//  DetailEventController+UITableView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension DetailEventController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstEventCell") as! FirstEventCell
            cell.imageEventCell.image = imageEvent
            return cell
            
        }
        else if indexPath.section == 1 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let dateEventCast = dateFormatter.string(from: dateEvent!)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondEventCell") as! SecondEventCell
            cell.titleEventLabel.text = titleEvent
            cell.addressEventLabel.text = addressEvent
            cell.dateEventLabel.text = dateEventCast
            return cell
        }
        else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdEventCell") as! ThirdEventCell
            cell.descEventLabel.text = descEvent
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fourthEventCell") as! FourthEventCell
            cell.nameEventCell.text = "Contact Person : " + nameEvent!
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fifthEventCell") as! FifthEventCell
            cell.phoneNameTitleCell.text = "Hubungi"
            cell.phoneNameCell.setTitle("✆ " + phoneEvent!, for: .normal)
            cell.phoneNameCell.addTarget(self, action: #selector(callButton), for: .touchUpInside)
            return cell
        }
        
        return UITableViewCell()
    }
    
}
