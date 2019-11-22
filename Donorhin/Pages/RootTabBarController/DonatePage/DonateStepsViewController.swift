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
      //MARK:- Setup delegate to change view
      destinationPVC.viewDidChangedDelegate =  self
      destinationPVC.vcList.first?.pageViewDelegate = destinationPVC
    }
  }
}
//MARK:- Step  Indicator Application
extension DonateStepsViewController:  StepIndicatorDelegate {
   func updateStepIndicator(toStep: Int) {
      //TODO : Update data ke database disini
      updateDatabase(toStep: toStep)
      self.stepIndicator = toStep - 1
      self.request?.currentStep = toStep
   }
  
  func updateDatabase(toStep: Int){
    let recordID = self.request?.idTracker
    if let recordID = recordID {
      Helper.database.fetch(withRecordID: recordID) { (record, error) in
        if let record = record, error == nil {
          //update your record here
          record.setValue(toStep, forKey: "current_step")
          Helper.database.save(record) { (_, error) in
            if error != nil {
              print (error!.localizedDescription)
            }
          }
        }
        else {
          print ("failed to update value with record id \(recordID)")
        }
      }
    }
    else {
      print("record id \(String(describing: recordID)) not found")
    }
  }
}

