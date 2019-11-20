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
    
    func didFilledSecondSection(cell: LongLabelAndTextCell, isFilled: Bool) {
        if !isFilled{
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
    
    func getPatientDueDate(cell: LongLabelAndTextCell, answer: String) {
        patientDueDate = answer
        checkValidity()
    }
    
    func getPatientBloodAmount(cell: LongLabelAndTextCell, answer: String) {
        patientBloodAmount = answer
        checkValidity()
    }
    
}

extension FormController: EmergencySwitchDelegate {
    
    func toogleSwitch(cell: LabelAndSwitchCell, isOn: Bool) {
        if isOn {
            patientEmergency = "1"
        }
        else {
            patientEmergency = "0"
        }
    }
    
}
