//
//  FormController+Delegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 16/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FormController : FormAnswerDelegate {
    
    func didFilledFirstSection(cell: LabelAndTextCell, isFilled: Bool) {
        if !isFilled {
            self.submitBarButton?.isEnabled = false
        }
    }
    
    func getPatientName(cell: LabelAndTextCell, answer: String) {
        patientName = answer
        checkValidity()
    }
    
    func getPatientHospital(cell: LabelAndTextCell, answer: String) {
        patientHospital = answer
        checkValidity()
    }
    
    func getPatientBloodType(cell: LabelAndTextCell, answer: String) {
        patientBloodType = answer
        checkValidity()
    }
    
    func getPatientDueDate(cell: LabelAndTextCell, answer: String) {
        patientDueDate = answer
        checkValidity()
    }
    
    func getPatientBloodAmount(cell: LabelAndTextCell, answer: String) {
        patientBloodAmount = answer
        checkValidity()
    }
    
    func didBeginEditingHospitalRow(cell: LabelAndTextCell) {
        self.performSegue(withIdentifier: "MoveToHospital", sender: self)
    }
    
}
