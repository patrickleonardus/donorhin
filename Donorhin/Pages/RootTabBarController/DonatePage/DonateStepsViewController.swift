//
//  DonateStepsViewController.swift
//  Donorhin
//
//  Created by Idris on 11/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

//MARK: StepIndicator protocol
protocol StepIndicatorDelegate {
   /**
    What this protocol do: Gimana biar step indicatornya ngupdate waktu di pencet button/ whatever it is.
    */
   func updateStepIndicator(toStep:Int)
}

//MARK: Class
class DonateStepsViewController: UIViewController {
  var request:TrackerModel?
  
  @IBOutlet weak var stepIndicatorView: StepIndicatorView!
  var stepIndicator: Int = 0 {
    didSet {
      self.stepIndicatorView.currentStep = stepIndicator
    }
  }
   
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let request = self.request {
      self.stepIndicator = request.currentStep - 1
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToSteps" {
      let destinationPVC = segue.destination as! RequestStepsPageViewController
      destinationPVC.step = self.request?.currentStep
      //MARK: Setup delegate to change view
      destinationPVC.viewDidChangedDelegate =  self
      destinationPVC.vcList.first?.pageViewDelegate = destinationPVC
    }
  }
}
//MARK:- Step  Indicator Application
extension DonateStepsViewController:  StepIndicatorDelegate {
   func updateStepIndicator(toStep: Int) {
      //TODO : Update data ke database disini
    print (self.request?.currentStep,toStep)
      self.stepIndicator = toStep - 1
      self.request?.currentStep = toStep
   }
}

