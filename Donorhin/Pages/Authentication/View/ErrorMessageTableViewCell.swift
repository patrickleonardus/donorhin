//
//  ErrorMessageTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 19/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class ErrorMessageTableViewCell: UITableViewCell{
    @IBOutlet weak var errorMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Colors.backgroundView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

