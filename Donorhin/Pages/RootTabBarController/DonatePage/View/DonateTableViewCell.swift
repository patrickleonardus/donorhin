//
//  DonateTableViewCell.swift
//  Donorhin
//
//  Created by Idris on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DonateTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var personImage: UIImageView!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
