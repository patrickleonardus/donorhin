//
//  SecondStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class SecondStepRequestViewController: UIViewController {
   
   var delegate : SecondStepTableDelegate?
   @IBOutlet var tableView: UITableView!
   var chosenDate : Date?
   var chosenUTD: PMIModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    stylingTableView()
  }
  
  
  @IBAction func buttonAcceptTapped(_ sender: UIButton) {
    self.setupAlertAccept()
  }
  @IBAction func buttonCancelTapped(_ sender: UIButton) {
    self.setupAlertDecline()
  }
  
  private func setupAlertAccept() {
    let alert = UIAlertController(title: "Apakah Anda yakin bersedia?", message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda", preferredStyle: .alert)
    let accept = UIAlertAction(title: "Ya", style: .default) { (_) in
      
    }
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func setupAlertDecline() {
    let alert = UIAlertController(title: "Apakah Anda yakin ingin menolak?", message: "Resipien akan langsung diinformasikan mengenai keputusan kesediaan Anda", preferredStyle: .alert)
    let accept = UIAlertAction(title: "Ya", style: .default) { (_) in
      
    }
    let cancel = UIAlertAction(title: "Tidak", style: .cancel, handler: nil)
    alert.addAction(accept)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
   
   //MARK:- Setting up Table View
   private func stylingTableView () {
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.isScrollEnabled = false
      self.tableView.backgroundColor = .white
      self.tableView.separatorStyle = .singleLine
      self.tableView.layer.cornerRadius = 10
   }
   
}
