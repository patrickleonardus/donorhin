//
//  DonateStepsViewController.swift
//  Donorhin
//
//  Created by Idris on 11/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

//MARK: StepIndicator protocol
protocol StepIndicatorDelegate {
   /**
    What this protocol do: Gimana biar step indicatornya ngupdate waktu di pencet button/ whatever it is.
    */
   func updateStepIndicator(nextStep:Int)
}

//MARK: Save data to DB
protocol TrackerDatabaseDelegate {
  func saveToDB (package: [String:Any?] )
}

//MARK: Class
class DonateStepsViewController: UIViewController {
  var request:TrackerModel?
  
  @IBOutlet weak var stepIndicatorView: StepIndicatorView!
  var stepIndicator: Int = 1 {
    didSet {
      self.stepIndicatorView.currentStep = stepIndicator
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print ("current step: \(self.request?.currentStep)")
    if let request = self.request {
      self.stepIndicator = request.currentStep 
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToSteps" {
      let destinationPVC = segue.destination as! RequestStepsPageViewController
      if let request = self.request {
        destinationPVC.tracker = request
      }
      else {
        destinationPVC.tracker?.currentStep = self.stepIndicator
      }
      //MARK:- Setup delegate to change view
      destinationPVC.viewDidChangedDelegate =  self
      destinationPVC.vcList.first?.pageViewDelegate = destinationPVC
    }
  }
  
  func stylingSixthStep() {
    "Anda sudah membantu satu nyawa lagi hari ini! Terimakasih telah mendonorkan darah Anda"
  }
}

//MARK:- Step  Indicator Application
extension DonateStepsViewController:  StepIndicatorDelegate {
  func updateStepIndicator(nextStep: Int) {
    //TODO : Update data ke database disini
    if let recordID = self.request?.idTracker {
      let keyValue = ["current_step": nextStep-1]
      Helper.updateToDatabase(keyValuePair: keyValue, recordID: recordID)
      self.stepIndicator = nextStep - 1
      self.request?.currentStep = nextStep
    }
  }
  
}

