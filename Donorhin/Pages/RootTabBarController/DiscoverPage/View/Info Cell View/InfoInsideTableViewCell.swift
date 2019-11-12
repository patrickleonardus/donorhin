//
//  InfoInsideTableViewCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class InfoInsideTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageInfo: UIImageView!
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var detailInfo: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
