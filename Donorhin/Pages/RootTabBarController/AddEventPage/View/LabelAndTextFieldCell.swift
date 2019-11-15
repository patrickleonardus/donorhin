//
//  LabelAndTextFieldCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LabelAndTextFieldCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var answer: UITextField!

    var delegate : AnswerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.answer.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if answer.text!.isEmpty {
            delegate?.didFilled(cell: self, isFilled: false)
        }
        else if !answer.text!.isEmpty{
            delegate?.didFilled(cell: self, isFilled: true)
        }
    }
}

protocol AnswerDelegate {
    func didFilled(cell: LabelAndTextFieldCell, isFilled: Bool)
}
