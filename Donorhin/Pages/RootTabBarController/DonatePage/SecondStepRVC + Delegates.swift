//
//  SecondStepRVC + TableView.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 17/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension SecondStepRequestViewController : UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      2
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 51
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
      if indexPath.row == 0 {
         cell.textLabel?.text = "Tanggal Kebutuhan"
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
         performSegue(withIdentifier: "GoToUTD", sender: nil)
      }
   }
   
   //MARK:- Prepare segue
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "GoToUTD" {
         let utdVC = segue.destination as! UTDDonorTableViewController
         utdVC.delegate = self
      }
   }
   
   
}

extension SecondStepRequestViewController: DelegateUTD {
   func seletedUTD(utd: PMIModel?) {
      if let utd = utd {
         let tableViewCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
         tableViewCell?.detailTextLabel!.text = utd.name
         tableViewCell?.accessoryType = .none
         tableViewCell?.isSelected = false
      }
   }
}

