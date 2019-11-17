//
//  LabelAndTextCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LabelAndTextCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    
    
    //MARK: - Initialize Var
    
    var personalTableViewSection = 0
    var personalTableViewRow = 0
    
    var delegate : FormAnswerDelegate?
    
    var patientName: String?
    var patientHospital: String?
    var patientBloodType: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.firstTextField.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if firstTextField.text!.isEmpty {
            delegate?.didFilledFirstSection(cell: self, isFilled: false)
        }
        
        else if !firstTextField.text!.isEmpty {
            delegate?.didFilledFirstSection(cell: self, isFilled: true)
            
            if personalTableViewSection == 0 {
                if personalTableViewRow == 0 {
                    patientName = textField.text
                    delegate?.getPatientName(cell: self, answer: patientName!)
                }
                else if personalTableViewRow == 1 {
                    patientHospital = textField.text
                    delegate?.getPatientHospital(cell: self, answer: patientHospital!)
                    
                }
                else if personalTableViewRow == 2 {
                    patientBloodType = textField.text
                    delegate?.getPatientBloodType(cell: self, answer: patientBloodType!)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}

protocol FormAnswerDelegate {
    func didFilledFirstSection(cell: LabelAndTextCell, isFilled: Bool)
    func didFilledSecondSection(cell: LongLabelAndTextCell, isFilled: Bool)
    func getPatientName(cell: LabelAndTextCell, answer: String)
    func getPatientHospital(cell: LabelAndTextCell, answer: String)
    func getPatientBloodType(cell: LabelAndTextCell, answer: String)
    func getPatientDueDate(cell: LongLabelAndTextCell, answer: String)
    func getPatientBloodAmount(cell: LongLabelAndTextCell, answer: String)
}
