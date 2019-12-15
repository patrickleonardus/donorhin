//
//  UIView + Loading Page.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

//global variable
var vSpinner : UIView?
var bgSpinner : UIView?

extension UIViewController {
  func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.1)
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = onView.center
    loadingView.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    
    let ai : UIActivityIndicatorView = UIActivityIndicatorView()
    ai.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    ai.style = .whiteLarge
    ai.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)
    
    
    DispatchQueue.main.async {
      loadingView.tag = 99
      spinnerView.tag = 100
      loadingView.addSubview(ai)
      spinnerView.addSubview(loadingView)
      onView.addSubview(spinnerView)
      onView.bringSubviewToFront(spinnerView)
      onView.bringSubviewToFront(ai)
    }
    ai.startAnimating()
  }
  
  func showSpinner(onView : UIView, x : Int, y : Int){
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.1)

    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = CGPoint(x: x, y: y)
    loadingView.backgroundColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10


    let ai : UIActivityIndicatorView = UIActivityIndicatorView()
    ai.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    ai.style = .whiteLarge
    ai.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)


    DispatchQueue.main.async {
      loadingView.tag = 99
      spinnerView.tag = 100
      loadingView.addSubview(ai)
      spinnerView.addSubview(loadingView)
      onView.addSubview(spinnerView)
      onView.bringSubviewToFront(spinnerView)
      onView.bringSubviewToFront(ai)
    }
    ai.startAnimating()
  }
  
  func removeSpinner() {
    DispatchQueue.main.async {
      self.view.viewWithTag(99)?.removeFromSuperview()
      self.view.viewWithTag(100)?.removeFromSuperview()
      vSpinner = nil
      bgSpinner = nil
    }
  }
  
}

protocol SpinnerDelegate {
  func hideSpinner()
}
