//
//  RegisterController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension RegisterController :UITableViewDelegate{
    
}

extension RegisterController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 17
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath) as? FormTableViewCell
        //masukin datanya
        guard let data = formItems?[indexPath.section] else {fatalError()}
        
        cell?.formTextField.placeholder = data.placeholder
        cell?.iconImageView.image = UIImage(named: data.img!)
        cell?.delegate = self
        
        cell?.backgroundColor = UIColor.white
        cell?.layer.cornerRadius = 10
        
        return cell!
    }
}
