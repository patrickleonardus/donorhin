//
//  FindController+UITableViewDelegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FindController: UITableViewDelegate {
    
}


extension FindController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let totalData = bloodRequstData?.count else { fatalError() }
        return totalData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        
        let data = bloodRequstData![indexPath.row]
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.status
        return cell
    }
    
    
}
