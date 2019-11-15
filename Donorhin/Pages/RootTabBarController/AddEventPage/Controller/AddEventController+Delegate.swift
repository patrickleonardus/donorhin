//
//  AddEventController+Delegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension AddEventController : CheckboxDelegate {
    
    func didCheck(cell: CheckboxAgreementCell, isChecked: Bool) {
        
        if isChecked {
            checkboxValidation = true
        }
        else {
            checkboxValidation = false
        }
    }
    
}

extension AddEventController : AnswerDelegate {
    
    func didFilled(cell: LabelAndTextFieldCell, isFilled: Bool) {
        if !isFilled {
            shareBarButton?.isEnabled = false
        }
    }
    
    func getTitle(cell: LabelAndTextFieldCell, data: String) {
        titleEvent = data
        checkValidity()
    }
    
    func getDesc(cell: LabelAndTextFieldCell, data: String) {
        descEvent = data
        checkValidity()
    }
    
    func getloc(cell: LabelAndTextFieldCell, data: String) {
        locEvent = data
        checkValidity()
    }
    
    func getStart(cell: LabelAndTextFieldCell, data: String) {
        startEvent = data
        checkValidity()
    }
    
    func getEnd(cell: LabelAndTextFieldCell, data: String) {
        endEvent = data
        checkValidity()
    }
    
    func getName(cell: LabelAndTextFieldCell, data: String) {
        nameEvent = data
        checkValidity()
    }
    
    func getPhone(cell: LabelAndTextFieldCell, data: String) {
        phoneEvent = data
        checkValidity()
    }
    
    
}
