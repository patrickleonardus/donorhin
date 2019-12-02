//
//  FindController+ScrollView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FindController: UIScrollViewDelegate{
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == tableView {
      let offsetPoint = scrollView.contentOffset
      
      if offsetPoint.y <= -10.0 {
        UIView.animate(withDuration: 0.2) {
          self.findBloodSegmentedControl.alpha = 0
        }
      }
      else if offsetPoint.y >= 0.0{
        UIView.animate(withDuration: 0.2) {
          self.findBloodSegmentedControl.alpha = 1
        }
      }
      
      let navBarHeight = Double((navigationController?.navigationBar.frame.height)!)
      
      if navBarHeight < 90.0 {
        UIView.animate(withDuration: 0.2) {
          self.profileImage.alpha = 0.0
        }
        
      }
      else if navBarHeight >= 90.0 {
        UIView.animate(withDuration: 0.2) {
          self.profileImage.alpha = 1.0
        }
      }
      
    }
  }
}

