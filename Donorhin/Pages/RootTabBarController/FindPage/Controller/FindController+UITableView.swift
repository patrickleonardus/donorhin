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
  
  //MARK: heightForRowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if let data = bloodRequestCurrent?[indexPath.row],
      let _ = data.donorDate,
      let _ = data.status
    {
      return 160
    } else {
      return 77
    }
  }
  
  //MARK: numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var totalData = 0
    
    if findBloodSegmentedControl.selectedSegmentIndex == 0 {
      if bloodRequestCurrent != nil {
        totalData = bloodRequestCurrent!.count
      } else {
        totalData = 0
      }
    } else {
      if bloodRequestHistory != nil {
        if bloodRequestHistory?.count != 0 {
          if let data = bloodRequestHistory?.count {
            totalData = data
          }
        } else {
          totalData = 0
        }
      } else {
        totalData = 0
      }
    }
    return totalData
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //MARK:- CURRENT
    if findBloodSegmentedControl.selectedSegmentIndex == 0 {
      if bloodRequestCurrent != nil {
        if bloodRequestCurrent?.count != 0 {
          
          let cell  = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FindBloodCustomCell
          
          if let data = bloodRequestCurrent?[indexPath.row],
            let donorDate = data.donorDate,
            let status = data.status
          {
            cell?.title.text = "Pendonor \(indexPath.row + 1)"
            cell?.address.text = data.donorHospitalName
            cell?.date.text = shrinkDate(donorDate)
            cell?.status.text = Steps.checkStep(status)
            
            cell?.buttonCallOutlet.phoneNumber = data.phoneNumber
            hidePlaceDateAndCall(cell: cell!, value: false)
            
          } else {
            cell?.title.text = "Pendonor \(indexPath.row + 1)"
            cell?.status.text = Steps.checkStep(0)
            hidePlaceDateAndCall(cell: cell!, value: true)
          }
          
          // MARK:- Call PMI button
          cell?.buttonCallOutlet.setTitle("Call PMI Pendonor", for: .normal)
          cell?.buttonCallOutlet.addTarget(self, action: #selector(callButton(sender:)), for: .touchUpInside)
          cell?.backgroundColor = UIColor.clear
          
          return cell!
        }
      }
    }
      //MARK: RIWAYAT
    else if findBloodSegmentedControl.selectedSegmentIndex == 1{
      
      if bloodRequestHistory != nil {
        if bloodRequestHistory?.count != 0 {
          let cell  = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FindBloodCustomCell
          guard let data = bloodRequestHistory?[indexPath.row] else {fatalError()}
          
          hidePlaceDateAndCall(cell: cell!, value: false)
          cell?.buttonCallOutlet.isHidden = true
          cell?.title.text = "Pendonor \(indexPath.row + 1)"
          cell?.address.text = data.donorHospitalName
          cell?.date.text = shrinkDate(data.donorDate!)
          cell?.status.text = Steps.checkStep(data.status!)
          
          cell?.backgroundColor = UIColor.clear
          
          
          return cell!
        }
      } else {
        print ("There's no history data")
      }
    }
    return UITableViewCell()
  }
  
  func hidePlaceDateAndCall(cell: FindBloodCustomCell,value: Bool) {
    cell.addressSV.isHidden = value
    cell.dateSV.isHidden = value
    cell.isUserInteractionEnabled = !value
    cell.buttonCallOutlet.isHidden = value
  }
  
  //MARK:- didSelectRowAt
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if findBloodSegmentedControl.selectedSegmentIndex == 0 {
      guard let data = bloodRequestCurrent?[indexPath.row] else {fatalError()}
      requestIdTrc = data.requestId
      trackerIdTrc = data.trackerId
      hospitalIdTrc = data.donorHospitalID
      currStepTrc = data.status
    }
      
    else {
      guard let data = bloodRequestHistory?[indexPath.row] else {fatalError()}
      requestIdTrc = data.requestId
      trackerIdTrc = data.trackerId
      hospitalIdTrc = data.donorHospitalID
      currStepTrc = data.status
    }
    
    performSegue(withIdentifier: "moveToTracker", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
