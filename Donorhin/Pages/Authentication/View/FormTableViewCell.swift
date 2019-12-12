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
    func infoButtonDidTap()
    func registerForKeyboardNotifications()
    func textFieldDidBeginEditing(cell:FormTableViewCell)
    func textFieldDidEndEditing()
    func clearTextField(cell:FormTableViewCell)
}

class FormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet var whiteBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var formTextField: UITextField!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    var delegate : FormCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.whiteBackgroundView.layer.cornerRadius = 10
        self.contentView.backgroundColor = Colors.backgroundView
    }
    
    @IBAction func buttonDidSelected(_ sender: Any) {
        delegate?.infoButtonDidTap()
    }
    
    
    @IBAction func clearDidTap(_ sender: Any) {
        delegate?.clearTextField(cell: self)
    }
    
    @IBAction func didBegin(_ sender: Any) {
        delegate?.registerForKeyboardNotifications()
        delegate?.textFieldDidBeginEditing(cell: self)
    }
    
    @IBAction func didEnd(_ sender: Any) {
       delegate?.textFieldDidEndEditing()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
