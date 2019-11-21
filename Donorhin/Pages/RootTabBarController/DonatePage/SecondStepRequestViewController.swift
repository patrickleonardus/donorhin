//
//  SecondStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class SecondStepRequestViewController: DonateStepViewController{
   //MARK:- Variables
   @IBOutlet var tableView: UITableView!
   @IBOutlet var tapRecognizer: UITapGestureRecognizer!
   var chosenUTD: DonatePMIModel?
   var picker = UIDatePicker()
   var chosenDate : Date? {
      didSet {
         let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
         cell.accessoryView = .none
         let desc = self.chosenDate?.description.prefix(10)
         cell.detailTextLabel?.text = String(desc ?? "")
      }
   }
   
  override func viewDidLoad() {
    super.viewDidLoad()
    stylingTableView()
    picker.styling()
    self.tapRecognizer.isEnabled = false
  }
  
  //MARK: Setting up alerts
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
   
   //MARK:- Setting up date picker
   func showDatePicker () {
      self.tapRecognizer.isEnabled = true
      picker.datePickerMode = .date
      self.view.addSubview(picker)
      self.constrainingDatePicker()
      self.view.bringSubviewToFront(picker)
      self.picker.addTarget(self, action: #selector(datePickerDidChanged), for: .valueChanged)
   }
   
   @objc private func datePickerDidChanged () {
      self.chosenDate = picker.date
   }
   
   private func constrainingDatePicker() {
      let safeArea = self.view.safeAreaLayoutGuide
      picker.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         picker.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
         picker.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
         picker.heightAnchor.constraint(equalToConstant: picker.frame.height),
         picker.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
      ])
   }
   
   @IBAction func closeDatePicker(_ sender: Any) {
      self.picker.removeFromSuperview()
      self.tapRecognizer.isEnabled = false
   }
   
   //MARK: - Action of pressed button
   @IBAction func buttonAcceptTapped(_ sender: UIButton) {
     self.setupAlertAccept()
   }
   @IBAction func buttonCancelTapped(_ sender: UIButton) {
     self.setupAlertDecline()
   }
}
