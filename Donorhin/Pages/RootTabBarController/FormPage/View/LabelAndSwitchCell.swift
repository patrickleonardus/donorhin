//
//  LabelAndSwitchCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LabelAndSwitchCell: UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    var delegate: EmergencySwitchDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchOutlet.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
    }
    
    @objc func switchChanged(_ sender: UISwitch){
        if sender.isOn {
            delegate?.toogleSwitch(cell: self, isOn: true)
        }
        else {
            delegate?.toogleSwitch(cell: self, isOn: false)
        }
    }
    
}

protocol EmergencySwitchDelegate {
    func toogleSwitch(cell: LabelAndSwitchCell, isOn: Bool)
}
