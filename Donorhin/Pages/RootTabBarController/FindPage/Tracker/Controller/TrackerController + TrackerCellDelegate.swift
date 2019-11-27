//
//  TrackerController + TrackerCellDelegate.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension TrackerController : TrackerCellDelegate {
   func showMoreInfo() {
      //TODO: Add segue ke info lengkap
    print ("add segue here")
    performSegue(withIdentifier: "goToInformationPage", sender: self)
   }
   
   @objc func didConfirmed() {
      //FIXME: Apa yang terjadi kalau konfirmasi di pencet?
      donorData?[0].donorStatus = .confirmed
      self.getTrackerItems { (stepItems) in
          self.stepItems = stepItems
      }
      trackerTableView.reloadData()
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! InformationController
        destination.navigationBarTitle =  "Info Komunitas"
        destination.sectionTotal = 2
    }
}
