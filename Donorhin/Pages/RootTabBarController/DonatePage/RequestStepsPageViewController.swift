//
//  RequestStepsPageViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class RequestStepsPageViewController: UIPageViewController {
  var id: Int!
  lazy var vcList: [UIViewController] = {
    let sb = UIStoryboard(name: "RequestStepsPageViewController", bundle: nil)
    switch self.id {
      case 1:
        return [sb.instantiateViewController(withIdentifier: "1")]
      case 2:
      return [sb.instantiateViewController(withIdentifier: "2")]
      case 3:
        return [sb.instantiateViewController(withIdentifier: "3")]
      case 4:
        return [sb.instantiateViewController(withIdentifier: "4")]
      case 5:
      return [sb.instantiateViewController(withIdentifier: "5")]
    default:
      return [sb.instantiateViewController(withIdentifier: "1")]
    }
  }()
      
  override func viewDidLoad() {
    super.viewDidLoad()
    if let firstViewController = self.vcList.first {
      self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }
}
