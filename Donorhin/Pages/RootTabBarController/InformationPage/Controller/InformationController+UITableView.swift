//
//  InformationController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension InformationController : UITableViewDelegate{
    
}

extension InformationController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTotal!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InformationTableViewCell
        //masukin datanya
        guard let data = infoItems?[indexPath.section] else {fatalError()}
        
        cell?.titleLabel.text = data.title
        cell?.backgroundColor = Colors.backgroundView
        cell?.infoType = data.type
        cell?.videoURLStr = data.videoURL
        cell?.longTextLabel.text = data.longText
        
        return cell!
    }
}
