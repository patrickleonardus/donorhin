//
//  TrackerController + TrackerCellDelegate.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

extension TrackerController : TrackerCellDelegate {
   func showMoreInfo() {
      //TODO: Add segue ke info lengkap
    print ("add segue here")
    performSegue(withIdentifier: "goToInformationPage", sender: self)
   }
   
  @objc func didConfirmed() {
    updateToDB {
      //TODO: Add Notif ya @idris
			guard let tracker = self.input else {return}
			Helper.getDataByID(tracker.idTracker) { (record) in
				if let record = record {
					if let idPendonor = record.value(forKey: "id_pendonor") as? CKRecord.Reference {
						Helper.getDataByID(idPendonor.recordID) { (result) in
							if let result = result {
								let token = result.value(forKey: "device_token") as! String
								Service.sendNotification("Resipien sudah menerima darah", [token], tracker.idRequest.recordName, 1, "0")
							}
						}
					}
				}
			}
			
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
        destination.navigationBarTitle =  "Info Umum"
        destination.sectionTotal = 2
    }
}
