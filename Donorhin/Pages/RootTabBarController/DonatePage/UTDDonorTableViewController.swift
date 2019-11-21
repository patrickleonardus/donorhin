//
//  UTDDonorTableViewController.swift
//  Donorhin
//
//  Created by Idris on 11/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

protocol DelegateUTD {
  func seletedUTD(utd: DonatePMIModel?)
}

class UTDDonorTableViewController: UITableViewController {
  var delegate: DelegateUTD?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Unit Tranfusi Darah"
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    return DummyPMI.list.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "UTDCell", for: indexPath)
    
    cell.textLabel?.text = DummyPMI.list[indexPath.row].name
    cell.detailTextLabel?.text = DummyPMI.list[indexPath.row].alamat
      return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedUTD = DummyPMI.list[indexPath.row]
    self.delegate?.seletedUTD(utd: selectedUTD)
    self.tableView.deselectRow(at: indexPath, animated: true)
    self.navigationController?.popViewController(animated: true)
  }
}
