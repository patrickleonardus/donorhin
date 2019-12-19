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
   func updateStepIndicator(keyValuePair package: [String:Any?])
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
  
}

//MARK:- Step  Indicator Application
extension DonateStepsViewController:  StepIndicatorDelegate {
  func updateStepIndicator(keyValuePair package: [String:Any?]) {
    //TODO : Update data ke database disini
    if let record = self.request {
			Helper.updateToDatabase(keyValuePair: package, recordID: record.idTracker)
			self.stepIndicator = package["current_step"] as! Int
    }
  }
  
}

