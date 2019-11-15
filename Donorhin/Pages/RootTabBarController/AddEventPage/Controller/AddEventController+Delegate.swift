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
        if isFilled {
            checkFormFilledCount += 1
        }
        else {
            checkFormFilledCount -= 1
        }
        
        if checkFormFilledCount == 7 {
            shareBarButton?.isEnabled = true
        }
        else if checkFormFilledCount != 7 {
            shareBarButton?.isEnabled = false
        }
        
        print(checkFormFilledCount)
    }
}
