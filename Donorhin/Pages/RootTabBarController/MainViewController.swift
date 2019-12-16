//
//  MainViewController.swift
//  Donorhin
//
//  Created by Idris on 11/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
class MainViewController: UITabBarController {
  
  var barSelected: Int?
  var tracker: TrackerModel?
    
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    if let barSelected  = self.barSelected {
      self.selectedIndex = barSelected
      if barSelected == 0 {
        guard let navigationController = self.viewControllers?[barSelected] as? UINavigationController ,
        let findViewController = navigationController.topViewController as? FindController else {return}
				findViewController.selectedData = self.tracker
      }
      else if barSelected == 1 {
        guard let navigationController = self.viewControllers?[barSelected] as? UINavigationController ,
        let donateViewController = navigationController.topViewController as? DonateController else {return}
        donateViewController.selectedData = self.tracker
      }
    }
  }
    
}
