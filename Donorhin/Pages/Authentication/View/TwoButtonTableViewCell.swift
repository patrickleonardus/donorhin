//
//  TwoButtonTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 18/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class TwoButtonTableViewCell: UITableViewCell{
    
    @IBOutlet weak var daftarOutlet: UIButton!

    @IBOutlet weak var masukNantiOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Colors.backgroundView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
