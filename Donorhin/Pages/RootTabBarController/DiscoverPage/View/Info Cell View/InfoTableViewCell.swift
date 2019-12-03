//
//  InfoTableViewCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewInfo: UITableView!
    
    var navigationBarTitle : String?
    
    var delegate : NavigationBarTitleDelegate?
    
    var infoData : [InfoModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        DummyDataForInfo().getInfoData { (infoData) in
            self.infoData = infoData
        }
      
      tableViewInfo.tableFooterView = UIView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
