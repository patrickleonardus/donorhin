//
//  InboxController+UITableView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension InboxController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell") as! InboxTableViewCell
    
    cell.layer.backgroundColor = UIColor.white.cgColor
    cell.layer.cornerRadius = 15
    
    cell.layer.borderWidth = 5
    cell.layer.borderColor = Colors.backgroundView.cgColor
    
    cell.labelInbox.text = "This is a Text \(indexPath.row + 1)"
    cell.imageInbox.image = UIImage(named: "user_profile")
    
    cell.imageInbox.layer.cornerRadius = 10
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
}
