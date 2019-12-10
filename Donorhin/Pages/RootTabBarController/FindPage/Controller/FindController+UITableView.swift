//
//  FindController+UITableViewDelegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FindController: UITableViewDataSource, UITableViewDelegate {
  
  //MARK: heightForRowAt
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if findBloodSegmentedControl.selectedSegmentIndex == 0 {
      //Load for current data
      if let data = bloodRequestCurrent?[indexPath.row] {
        if data.status == 0 {
          return 77
        } else {
          return 160
        }
      } else {
        return 77
      }
    } else {
      //load for history data
      return 160
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
  
  //MARK:- Set up cell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //MARK: CURRENT
    if findBloodSegmentedControl.selectedSegmentIndex == 0 {
      if bloodRequestCurrent != nil {
        if bloodRequestCurrent?.count != 0 {
          let cell  = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FindBloodCustomCell
          
          if let data = bloodRequestCurrent?[indexPath.row] {
          
            if data.status ?? 0 < 2 { //(handling logic patrick)
              //Skenario sebelum pendonor memilih UTD dan Tanggal
              setupSmallCell(cell: cell!, row: indexPath.row, status: data.status ?? 0)
              
            } else {
              //Skenario sudah memilih UTD dan Tanggal
              guard
                let donorDate = data.donorDate,
                let status = data.status
                else  {
                  fatalError("HARUSNYA MEREKA GA NIL")
                  
              }
              cell?.title.text = "Pendonor \(indexPath.row + 1)"
              cell?.address.text = data.donorHospitalName
              cell?.date.text = shrinkDate(donorDate)
              cell?.status.text = Steps.checkStep(status)
              
              cell?.buttonCallOutlet.phoneNumber = data.phoneNumber
              hidePlaceDateAndCall(cell: cell!, value: false)
              cell?.buttonCallOutlet.setTitle("Call PMI Pendonor", for: .normal)
              cell?.buttonCallOutlet.addTarget(self, action: #selector(callButton(sender:)), for: .touchUpInside)
            }
            
          } else {
            //Skenario bloodRequestCurrent[index] nya nil : masih belum ditemukan (logic Vebby)
            setupSmallCell(cell: cell!, row: indexPath.row, status: 0)
          }
          
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
  
  func setupSmallCell(cell: FindBloodCustomCell,row: Int, status : Int) {
    cell.title.text = "Pendonor \(row + 1)"
    
    cell.status.text = Steps.checkStep(status)
    hidePlaceDateAndCall(cell: cell, value: true)
  }
  
  func hidePlaceDateAndCall(cell: FindBloodCustomCell,value: Bool) {
    cell.addressSV.isHidden = value
    cell.iconChevron.isHidden = value
    cell.buttonCallOutlet.isHidden = value
    cell.isUserInteractionEnabled = !value
    cell.dateSV.isHidden = value
  }
  
  //MARK:- Selected Row
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
