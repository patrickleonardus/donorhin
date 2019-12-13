//
//  RequestStepsPageViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

//MARK: Change View Protocol
protocol StepViewChangingDelegate {
  func changeShowedView(toStep: Int, tracker: TrackerModel?)
}

//MARK: Class
class RequestStepsPageViewController: UIPageViewController {
  var viewDidChangedDelegate: StepIndicatorDelegate?
  
  var tracker: TrackerModel?
  
  lazy var vcList: [DonateStepViewController] = {
    let sb = UIStoryboard(name: "RequestStepsPageViewController", bundle: nil)
    
    switch self.tracker?.currentStep {
    case StepsEnum.findingDonor_0:
        return [sb.instantiateViewController(withIdentifier: "langkah1") as! FirstStepRequestViewController]
    case StepsEnum.donorFound_1:
      return [sb.instantiateViewController(withIdentifier: "langkah2") as! SecondStepRequestViewController]
    case StepsEnum.willDonor_2:
        return [sb.instantiateViewController(withIdentifier: "langkah3") as! DonateStepViewController]
    case StepsEnum.willVerif_3:
        return [sb.instantiateViewController(withIdentifier: "langkah4") as! DonateStepViewController]
    case StepsEnum.donoring_4:
      return [sb.instantiateViewController(withIdentifier: "langkah5") as! DonateStepViewController]
    case StepsEnum.received_6:
      return [sb.instantiateViewController(withIdentifier: "langkah6") as! DonateStepViewController]
    default:
      print ("Masuk ke default vcList")
      return [sb.instantiateViewController(withIdentifier: "langkah6") as! DonateStepViewController]
    }
  }()
      
  override func viewDidLoad() {
    super.viewDidLoad()
    if let firstViewController = self.vcList.first {
      if let fifthVC =  firstViewController as? FifthStepRequestViewController { //step == 5 || step == 6
        if let tracker = self.tracker {
          fifthVC.step = tracker.currentStep
        }
      }
      self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
      firstViewController.recieveRequest(self.tracker)
      firstViewController.trackerModel = self.tracker
    }
  }
}

//MARK:- StepViewChangingDelegate Application
extension RequestStepsPageViewController : StepViewChangingDelegate{
  
  func changeShowedView(toStep: Int, tracker: TrackerModel?) {
    if toStep < 5 {
      self.tracker = tracker
      self.tracker?.currentStep =  toStep-1
      self.viewDidChangedDelegate?.updateStepIndicator(nextStep: toStep)
      let sb = UIStoryboard(name: "RequestStepsPageViewController", bundle: nil)
      let viewControllers = [sb.instantiateViewController(withIdentifier: "langkah\(toStep)") as! DonateStepViewController]
      self.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
      viewControllers.first?.pageViewDelegate = self
      viewControllers.first?.recieveRequest(tracker)
    }
    else {
      self.tracker = tracker
      self.tracker?.currentStep =  toStep
      self.viewDidChangedDelegate?.updateStepIndicator(nextStep: toStep)
    }
  }
  
  
}
