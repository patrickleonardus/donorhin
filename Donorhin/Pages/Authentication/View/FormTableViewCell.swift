//
//  FormTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

protocol FormCellDelegate {
   func getData()
}

class FormTableViewCell: UITableViewCell {

    var delegate : FormCellDelegate?
    
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

class ButtonTableViewCell: UITableViewCell{
    
    @IBOutlet weak var buttonOutlet: CustomButtonRounded!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Colors.backgroundView
        self.buttonOutlet.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class AgreementTableViewCell: UITableViewCell{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Colors.backgroundView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

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

