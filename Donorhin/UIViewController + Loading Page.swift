//
//  UIView + Loading Page.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

var vSpinner : UIView? //global variable

extension UIViewController {
   func showSpinner(onView : UIView) {
      let spinnerView = UIView.init(frame: onView.bounds)
      spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.40)
      let ai = UIActivityIndicatorView.init(style: .whiteLarge)
      ai.startAnimating()
      ai.center = spinnerView.center
      
      DispatchQueue.main.async {
         spinnerView.addSubview(ai)
         onView.addSubview(spinnerView)
         onView.bringSubviewToFront(spinnerView)
      }
      
      vSpinner = spinnerView
   }
   
   func removeSpinner() {
      DispatchQueue.main.async {
         vSpinner?.removeFromSuperview()
         vSpinner = nil
      }
   }
}

protocol SpinnerDelegate {
   func hideSpinner() 
}
