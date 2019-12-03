//
//  SecondCell.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class SecondCell: UITableViewCell {
    
    
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var textCell: UILabel!
    @IBOutlet weak var profileTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundViewCell.layer.cornerRadius = 10
        backgroundViewCell.backgroundColor = UIColor.white
        
        self.backgroundColor = Colors.backgroundView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
