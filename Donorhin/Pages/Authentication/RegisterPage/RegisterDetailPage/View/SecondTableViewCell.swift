//
//  SecondTableViewCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 04/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleText: UILabel!
  @IBOutlet weak var longText: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
      
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
