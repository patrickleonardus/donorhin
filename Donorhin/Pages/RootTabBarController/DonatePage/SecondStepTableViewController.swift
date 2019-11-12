//
//  SecondStepTableViewController.swift
//  Donorhin
//
//  Created by Idris on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class SecondStepTableViewController: UITableViewController {
  @IBOutlet weak var utdLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    performSegue(withIdentifier: "GoToUTD", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToUTD" {
      let utdVC = segue.destination as! UTDDonorTableViewController
      utdVC.delegate = self
    }
  }
}

extension SecondStepTableViewController: DelegateUTD {
  func seletedUTD(utd: PMIModel?) {
    if let utd = utd {
      self.utdLabel.text = utd.name
    }
  }
}
