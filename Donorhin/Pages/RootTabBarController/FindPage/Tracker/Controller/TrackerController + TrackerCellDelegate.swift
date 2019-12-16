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
    updateToDB {
      //TODO: Add Notif ya @idris
    }
    self.getTrackerItems { (stepItems) in
      self.stepItems = stepItems
    }
    trackerTableView.reloadData()
  }
  
  func updateToDB ( completionHandler: @escaping  () -> Void){
    guard let trackerID = self.input?.idTracker else {
    print ("Failed to modify current step to database")
      completionHandler() ; return  }
    Helper.updateToDatabase(keyValuePair: ["current_step":StepsEnum.done_5], recordID: trackerID)
    completionHandler()
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! InformationController
        destination.navigationBarTitle =  "Info Komunitas"
        destination.sectionTotal = 2
    }
}
