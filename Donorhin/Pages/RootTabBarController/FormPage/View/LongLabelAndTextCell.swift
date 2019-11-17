//
//  LongLabelAndTextCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 16/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LongLabelAndTextCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    
    var detailTableViewSection = 0
    var detailTableViewRow = 0
    
    var delegate : FormAnswerDelegate?
    
    var patientDueDate: String?
    var patientBloodAmount: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.secondTextField.delegate = self
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if secondTextField.text!.isEmpty {
            delegate?.didFilledSecondSection(cell: self, isFilled: false)
        }
        else if !secondTextField.text!.isEmpty {
            delegate?.didFilledSecondSection(cell: self, isFilled: true)
            
            if detailTableViewSection == 1 {
                if detailTableViewRow == 0 {
                    patientDueDate = textField.text
                    delegate?.getPatientDueDate(cell: self, answer: patientDueDate!)
                }
                else if detailTableViewRow == 1 {
                    patientBloodAmount = textField.text
                    delegate?.getPatientBloodAmount(cell: self, answer: patientBloodAmount!)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
}
