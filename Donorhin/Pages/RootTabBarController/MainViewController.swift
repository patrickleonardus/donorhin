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
  var rootViewController : UIViewController?
    
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    if let barSelected  = self.barSelected {
      self.selectedIndex = barSelected
      if barSelected == 0 {
        guard let navigationController = self.viewControllers?[barSelected] as? UINavigationController ,
        let findViewController = navigationController.topViewController as? FindController else {return}
      }
      else if barSelected == 1 {
        guard let navigationController = self.viewControllers?[barSelected] as? UINavigationController ,
        let donateViewController = navigationController.topViewController as? DonateController else {return}
        donateViewController.selectedData = self.tracker
      }
    }
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if rootViewController is FindController {
            guard let navigationController = self.viewControllers?[0] as? UINavigationController ,
            let findViewController = navigationController.topViewController as? FindController else { return }
            navigationController.pushViewController(findViewController, animated: true)
        }
        else if rootViewController is DonateController {
            guard let navigationController = self.viewControllers?[1] as? UINavigationController ,
            let donateViewController = navigationController.topViewController as? DonateController else { return }
            navigationController.pushViewController(donateViewController, animated: true)
        }
        else if rootViewController is DiscoverController {
            guard let navigationController = self.viewControllers?[2] as? UINavigationController ,
            let discoverViewController = navigationController.topViewController as? DiscoverController else { return }
            navigationController.pushViewController(discoverViewController, animated: true)
        }
    }
}
