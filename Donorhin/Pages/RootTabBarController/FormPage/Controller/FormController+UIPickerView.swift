//
//  FormController+UIPickerView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 16/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FormController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let data = formBloodType?[row] else {fatalError()}
        return data.bloodType
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let data = formBloodType?[row] else {fatalError()}
        
        let cell = personalTableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! LabelAndTextCell
        cell.firstTextField.text = data.bloodType
    }
    
}
