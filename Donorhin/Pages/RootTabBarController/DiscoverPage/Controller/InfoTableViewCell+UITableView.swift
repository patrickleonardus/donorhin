//
//  InfoTableViewCell+UITableView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension InfoTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = infoData?.count else {fatalError()}
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoInsideCell") as! InfoInsideTableViewCell
        
        guard let data = infoData?[indexPath.row] else {fatalError()}
        
        cell.imageInfo.layer.cornerRadius = cell.imageInfo.frame.height/2
        cell.imageInfo.contentMode = UIView.ContentMode.scaleAspectFill
        
        cell.imageInfo.image = UIImage(named: data.image!)
        cell.titleInfo.text = data.title
        cell.detailInfo.text = data.description
        
        return cell
    }
    
    
}
