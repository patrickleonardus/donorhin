//
//  CheckboxAgreementCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class CheckboxAgreementCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: CheckBox!
    
    var delegate: CheckboxDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkBox.style = .tick
        
        //MARK: - Tap untuk checkbox
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox(_:)))
        checkBox.addGestureRecognizer(tap)
        
    }

    @objc func toggleCheckbox(_ sender: UITapGestureRecognizer){
        
        if checkBox.isChecked {
            checkBox.isChecked = false
            delegate?.didCheck(cell: self, isChecked: false)
        }
        else {
            checkBox.isChecked = true
            delegate?.didCheck(cell: self, isChecked: true)
        }
        
    }

}

protocol CheckboxDelegate {
    func didCheck(cell: CheckboxAgreementCell, isChecked: Bool)
}
