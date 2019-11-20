//
//  FormTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

protocol FormCellDelegate {
    func buttonDidTap()
}

class FormTableViewCell: UITableViewCell {
    
    @IBOutlet var whiteBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var formTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.whiteBackgroundView.layer.cornerRadius = 10
        self.contentView.backgroundColor = Colors.backgroundView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
