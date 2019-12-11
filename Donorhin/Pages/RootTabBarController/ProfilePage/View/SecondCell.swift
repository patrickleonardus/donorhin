//
//  SecondCell.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

protocol TextProtocol {
    func setDate(_ textView:UITextView)
}
class SecondCell: UITableViewCell, UITextViewDelegate {
    
    
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var textCell: UILabel!
    @IBOutlet weak var profileTextField: UITextField!
    var delegate: TextProtocol?
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.setDate(textView)
           return true
    }
}
