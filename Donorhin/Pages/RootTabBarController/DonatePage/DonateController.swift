//
//  DonateController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DonateController: UIViewController {

  @IBOutlet weak var switchButtonStatusDonor: UISwitch!
  @IBOutlet weak var historyDonorSegmentedControl: UISegmentedControl!
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var coverView: CustomMainView!
  final private let cellReuseIdentifier = "DonateCell"
  var selectedRow:Request?
  var segmented: History {
      if historyDonorSegmentedControl.selectedSegmentIndex == 0 {
        return .active
      } else {
        return.history
      }
  }
  var listData: [Request] = []
  var profileImage = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setProfileImageNavBar(self.profileImage)
    self.setupTabledView()
    self.getData()
    if self.listData.count > 0 {
      self.coverView.isHidden = true
    }
    else {
      self.coverView.isHidden = false
    }
  }
  
  //MARK: - get data from database
  private func getData() {
    DummyDataDonate.getData(self.segmented) { (res) in
      if let res = res {
        self.listData = res
        self.tableview.reloadData()
      }
    }
  }
  
  //MARK: - setup tableview
  private func setupTabledView() {
    self.tableview.delegate = self
    self.tableview.dataSource = self
    self.tableview.register(UINib(nibName: "DonateTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
  }
  
  //MARK: - segmented control action when tapped
  @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
    self.historyDonorSegmentedControl = sender
    self.getData()
  }
}

extension DonateController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.listData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! DonateTableViewCell
    cell.titleLabel.text = self.listData[indexPath.row].user
    cell.subtitleLabel.text = "\(self.listData[indexPath.row].step)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedRow = self.listData[indexPath.row]
    performSegue(withIdentifier: "GoToStep", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToStep" {
      let stepVC = segue.destination as! DonateStepsViewController
      stepVC.request = self.selectedRow
    }
  }
}
