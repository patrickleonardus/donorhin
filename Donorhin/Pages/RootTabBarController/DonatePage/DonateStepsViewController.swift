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
  lazy var stepIndicator: Int = {
    if let request = self.request {
      self.stepIndicatorView.currentStep = request.currentStep
      return request.currentStep
    }
    return 1
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    if let request = request {
      self.title = "Pendonor 1"
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToSteps" {
      let destinationVC = segue.destination as! RequestStepsPageViewController
      destinationVC.id = self.stepIndicator + 1
    }
  }
}

