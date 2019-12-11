//
//  TrackerController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension TrackerController : UITableViewDelegate {
    
}

extension TrackerController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UDDevice.heightScreen
        if height < 1334 {
            if indexPath.section == 3 {
               return 200
            }
            return 160
        }
        else {
            if indexPath.section == 3 {
               return 160
            }
        }
        return 123
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 20
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "trackerCell", for: indexPath) as? TrackerDonorTableViewCell
        print("making cell")
        //masukin datanya
        guard let data = stepItems?[indexPath.section] else {fatalError()}
        cell?.delegate = self
        
        cell?.informationText?.text = data.description
        cell?.buttonText.setTitle(data.buttonStr, for: .normal)
        
        cell?.backgroundColor = UIColor.white
        cell?.layer.cornerRadius = 10
        cell?.clipsToBounds = true
       
        if indexPath.section == 0 {
            cell?.buttonText.addTarget(self, action: #selector(callPMIResepien), for: .touchUpInside)
        }
        else if indexPath.section == 1 {
            cell?.buttonText.addTarget(self, action: #selector(callPMIPendonor), for: .touchUpInside)
        }
        else if indexPath.section == 4 {
            cell?.confirmButton.addTarget(self, action: #selector(didConfirmed), for: .touchUpInside)
      }
        
//        cell?.confirmButton.addTarget(self, action: #selector(confirmed), for: .touchUpInside)
        
        switch data.status {
        case .onGoing?: cell?.setupView(status: .onGoing, number: indexPath.section+1)
            break
        case .toDo?: cell?.setupView(status: .toDo, number: indexPath.section+1)
            break
        case .done?: cell?.setupView(status: .done, number: indexPath.section+1)
            break
        case .none:
            break
        }
        
        return cell!
    }

}


