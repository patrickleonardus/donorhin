//
//  SecondStepRVC + TableView.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 17/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

//MARK:- Setting up table view
extension SecondStepRequestViewController : UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 2
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 51
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
      if indexPath.row == 0 {
         cell.textLabel?.text = "Tanggal donor"
         cell.accessoryView = UIImageView(image: UIImage(named: "calendar20"))
      } else {
         cell.textLabel?.text = "Lokasi UTD Mendonor"
         cell.accessoryType = .disclosureIndicator
      }
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if  indexPath.row == 0 {
         showDatePicker()
      }  else if indexPath.row == 1 {
         performSegue(withIdentifier: "showHospitalList", sender: self)
         
//         performSegue(withIdentifier: "GoToUTD", sender: nil)
      }
   }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination as! HospitalController
    destination.hospitalDelegate = self
  }
}

//MARK:- Extension DelegateUTD
extension SecondStepRequestViewController:HospitalDelegate {
  func selectedHospital(hospital: HospitalModel) {
    self.chosenHospital = hospital
    let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
    cell?.accessoryType = .none
    cell?.detailTextLabel?.text = chosenHospital?.name
    cell?.isSelected = false
    self.buttonBersedia.isEnabled = isFilled
  }
}

