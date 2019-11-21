//
//  RequestStepsPageViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
protocol MovingDelegate {
   /**
    What this protocol do: Gimana biar step view nya bisa pindah2waktu di pencet button/ whatever it is.
    */
   func moveTo(step:Int)
}

class RequestStepsPageViewController: UIPageViewController {
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
      return [sb.instantiateViewController(withIdentifier: "langkah1") as! DonateStepViewController]
    }
  }()
      
  override func viewDidLoad() {
    super.viewDidLoad()
    if let firstViewController = self.vcList.first {
      self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
      
    }
  }
}
