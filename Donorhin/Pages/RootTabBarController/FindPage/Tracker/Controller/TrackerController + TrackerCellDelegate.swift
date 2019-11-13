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
   }
   
   @objc func didConfirmed() {
      //segue dll
      donorData?[0].donorStatus = .confirmed
      self.getTrackerItems { (stepItems) in
          self.stepItems = stepItems
      }
      trackerTableView.reloadData()
   }
}