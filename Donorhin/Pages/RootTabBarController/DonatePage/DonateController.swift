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
  var listData = ListDonate.list
  var profileImage = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setProfileImageNavBar(self.profileImage)
    self.setupTabledView()
    if self.listData.count > 0 {
      self.coverView.isHidden = true
    }
  }
  
  private func setupTabledView() {
    self.tableview.delegate = self
    self.tableview.dataSource = self
    self.tableview.register(UINib(nibName: "DonateTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
  }
}

extension DonateController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.listData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! DonateTableViewCell
    cell.titleLabel.text = self.listData[indexPath.row].user
    return cell
  }
}
