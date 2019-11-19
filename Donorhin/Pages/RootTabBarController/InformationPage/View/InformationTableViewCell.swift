//
//  TrackerTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var longTextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var videoLayer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.videoLayer.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
