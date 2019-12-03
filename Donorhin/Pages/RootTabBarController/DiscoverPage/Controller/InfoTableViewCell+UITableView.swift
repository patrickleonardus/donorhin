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
      
      if indexPath.row == 4 {
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
      }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationBarTitle = "Cara Penggunaan Donorhin"
            delegate?.getNavigationTitle(cell: self, title: navigationBarTitle!)
        }
        else if indexPath.row == 1 {
            navigationBarTitle = "Info Donor"
            delegate?.getNavigationTitle(cell: self, title: navigationBarTitle!)
        }
        else if indexPath.row == 2 {
            navigationBarTitle = "Info Komunitas"
            delegate?.getNavigationTitle(cell: self, title: navigationBarTitle!)
        }
        else if indexPath.row == 3 {
            navigationBarTitle = "Unit Transfusi Darah"
            delegate?.getNavigationTitle(cell: self, title: navigationBarTitle!)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

protocol NavigationBarTitleDelegate {
    func getNavigationTitle(cell: InfoTableViewCell, title : String)
}
