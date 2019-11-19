//
//  ButtonTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 18/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell{
    
    @IBOutlet weak var buttonOutlet: CustomButtonRounded!
    
    var delegate: FormCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Colors.backgroundView
        self.buttonOutlet.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func buttonDidTap(_ sender: Any) {
        delegate?.buttonDidTap()
    }
}
