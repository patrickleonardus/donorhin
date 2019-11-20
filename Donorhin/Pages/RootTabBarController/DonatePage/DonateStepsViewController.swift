//
//  DonateStepsViewController.swift
//  Donorhin
//
//  Created by Idris on 11/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DonateStepsViewController: UIViewController {
  var request:TrackerModel?
   
  @IBOutlet weak var stepIndicatorView: StepIndicatorView!
   
//  lazy var stepIndicator: Int = {
//    if let request = self.request {
//      self.stepIndicatorView.currentStep = request.currentStep - 1
//      return request.currentStep - 1
//    }
//    return 1
//    print ("request is nil")
//  }()
  var stepIndicator: Int = 0 {
    didSet {
      self.stepIndicatorView.currentStep = stepIndicator
    }
  }
   
  override func viewDidLoad() {
    super.viewDidLoad()
    if let request = self.request {
      print ("foo")
      self.stepIndicator = request.currentStep - 1
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToSteps" {
      let destinationVC = segue.destination as! RequestStepsPageViewController
      destinationVC.step = self.stepIndicator + 1
      destinationVC.vcList.first?.movingDelegate = self
    }
  }
}
//MARK:- Moving delegate
extension DonateStepsViewController:  MovingDelegate {
   func moveTo(step: Int) {
      self.stepIndicator = step
      print (self.stepIndicator)
   }
}

