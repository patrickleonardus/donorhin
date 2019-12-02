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
    
    let height : CGFloat = 160
    
    return height
  }
  
  //MARK: numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var totalData = 0
    
    if findBloodSegmentedControl.selectedSegmentIndex == 0 {
      if bloodRequestCurrent != nil {
        if bloodRequestCurrent?.count != 0 {
          totalData = 1
        }
        else if bloodRequestCurrent?.count == 0{
          totalData = 0
        }
      }
      else {
        totalData = 0
      }
    }
    else {
      if bloodRequestHistory != nil {
        if bloodRequestHistory?.count != 0 {
          if let data = bloodRequestHistory?.count {
            totalData = data
          }
        }
        else {
          totalData = 0
        }
      }
      else {
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
          guard let data = bloodRequestCurrent?[indexPath.row] else {fatalError()}
          
          cell?.title.text = "Pendonor \(indexPath.row + 1)"
          cell?.address.text = data.donorHospitalName
          
          cell?.date.text = shrinkDate(data.donorDate!)
          cell?.status.text = Steps.checkStep(data.status!)
          cell?.buttonCallOutlet.phoneNumber = data.phoneNumber
          
          // button untuk call pmi
          cell?.buttonCallOutlet.setTitle("Call PMI Pendonor", for: .normal)
          cell?.buttonCallOutlet.isHidden = false
          cell?.buttonCallOutlet.addTarget(self, action: #selector(callButton(sender:)), for: .touchUpInside)
          
          cell?.backgroundColor = UIColor.clear
          
          //MARK:- Ini buat bikin kotak ditiap cellnya dan kasih space antara cell
          // kotak kota yg warna putih itu loh
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
      }
    }
      //MARK: RIWAYAT
    else if findBloodSegmentedControl.selectedSegmentIndex == 1{
      
      if bloodRequestHistory != nil {
        if bloodRequestHistory?.count != 0 {
          let cell  = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FindBloodCustomCell
          guard let data = bloodRequestHistory?[indexPath.row] else {fatalError()}
          
          cell?.title.text = "Pendonor \(indexPath.row + 1)"
          cell?.address.text = data.donorHospitalName
          cell?.date.text = shrinkDate(data.donorDate!)
          cell?.status.text = Steps.checkStep(data.status!)
          
          cell?.buttonCallOutlet.isHidden = true
          
          cell?.backgroundColor = UIColor.clear
          
          //MARK:- Ini buat bikin kotak ditiap cellnya dan kasih space antara cell
          // kotak kota yg warna putih itu loh
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
      } else {
        print ("There's no history data")
      }
    }
    return UITableViewCell()
  }
  
  
  //MARK:- didSelectRowAt
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if findBloodSegmentedControl.selectedSegmentIndex == 0 {
      guard let data = bloodRequestCurrent?[indexPath.row] else {fatalError()}
      //            navBarTitle = data.name
      requestIdTrc = data.requestId
      trackerIdTrc = data.trackerId
      hospitalIdTrc = data.donorHospitalID
      currStepTrc = data.status
    }
      
    else {
      guard let data = bloodRequestHistory?[indexPath.row] else {fatalError()}
      //            navBarTitle = data.name
      requestIdTrc = data.requestId
      trackerIdTrc = data.trackerId
      hospitalIdTrc = data.donorHospitalID
      currStepTrc = data.status
    }
    
    performSegue(withIdentifier: "moveToTracker", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
