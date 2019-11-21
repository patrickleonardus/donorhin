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
  func changeShowedView(toStep: Int)
}

//MARK: Class
class RequestStepsPageViewController: UIPageViewController {
  var viewDidChangedDelegate: StepIndicatorDelegate?
  
  var step: Int!
  
  lazy var vcList: [DonateStepViewController] = {
    let sb = UIStoryboard(name: "RequestStepsPageViewController", bundle: nil)
    switch self.step {
      case 1:
        return [sb.instantiateViewController(withIdentifier: "langkah1") as! DonateStepViewController]
      case 2:
      return [sb.instantiateViewController(withIdentifier: "langkah2") as! DonateStepViewController]
      case 3:
        return [sb.instantiateViewController(withIdentifier: "langkah3") as! DonateStepViewController]
      case 4:
        return [sb.instantiateViewController(withIdentifier: "langkah4") as! DonateStepViewController]
      case 5:
      return [sb.instantiateViewController(withIdentifier: "langkah5") as! DonateStepViewController]
    default:
      return [sb.instantiateViewController(withIdentifier: "langkah5") as! DonateStepViewController]
    }
  }()
      
  override func viewDidLoad() {
    super.viewDidLoad()
    print (self.vcList.first)
    if let firstViewController = self.vcList.first {
      if let fifthVC =  firstViewController as? FifthStepRequestViewController { //step == 5 || step == 6
        fifthVC.step = step
      }
      self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }
}

//MARK:- StepViewChangingDelegate Application
extension RequestStepsPageViewController : StepViewChangingDelegate{
  func changeShowedView(toStep: Int) {
    if toStep < 6 {
      self.step =  toStep
      self.viewDidChangedDelegate?.updateStepIndicator(toStep: toStep)
      let sb = UIStoryboard(name: "RequestStepsPageViewController", bundle: nil)
      let viewControllers = [sb.instantiateViewController(withIdentifier: "langkah\(toStep)") as! DonateStepViewController]
      self.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
      viewControllers.first?.pageViewDelegate = self
    }
    else {
      self.step =  toStep
      self.viewDidChangedDelegate?.updateStepIndicator(toStep: toStep)
    }
  }
  
  
}
