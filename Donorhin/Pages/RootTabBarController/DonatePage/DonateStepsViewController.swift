//
//  DonateStepsViewController.swift
//  Donorhin
//
//  Created by Idris on 11/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DonateStepsViewController: UIViewController {
  var request:Request?
  @IBOutlet weak var stepIndicatorView: StepIndicatorView!
  lazy var stepIndicator: Int = {
    if let request = self.request {
      self.stepIndicatorView.currentStep = request.step
      return request.step
    }
    return 1
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    if let request = request {
      self.title = request.user
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToSteps" {
      let destinationVC = segue.destination as! RequestStepsPageViewController
      destinationVC.id = self.stepIndicator + 1
    }
  }
}

