//
//  DonateStepViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 21/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
protocol DonateStepViewControllerDelegate {
  func recieveRequest(_ tracker: TrackerModel?)
}

class DonateStepViewController: UIViewController, DonateStepViewControllerDelegate{
   
   var pageViewDelegate :  StepViewChangingDelegate?
  var trackerModel : TrackerModel?
   /**
     Biar gampang pindah2 halaman
    */
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
  
  func recieveRequest(_ tracker: TrackerModel?) {
  }
}

