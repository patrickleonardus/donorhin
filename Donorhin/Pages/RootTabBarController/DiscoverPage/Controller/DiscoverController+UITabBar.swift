//
//  DiscoverController+UITabBar.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 21/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension DiscoverController : UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    
    let fromView = tabBarController.selectedViewController?.view
    let toView = viewController.view
    
    if fromView != toView {
      UIView.transition(from: fromView!, to: toView!, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
    }
    
    return true
  }
}
