//
//  AgreementTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 18/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
protocol AgreementDelegate {
  func checkAgreementCheckBox(_ isCheck: Bool)
  func goToPrivacy()
}
class AgreementTableViewCell: UITableViewCell {
  var delegate: AgreementDelegate!
  @IBOutlet weak var checkBoxAgreement: CheckBox!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    self.contentView.backgroundColor = Colors.backgroundView
    checkBoxAgreement.style = .tick
    checkBoxAgreement.borderStyle = .roundedSquare(radius: 2)
    checkBoxAgreement.uncheckedBorderColor = Colors.red
    checkBoxAgreement.checkboxBackgroundColor = Colors.red
    checkBoxAgreement.checkmarkColor = Colors.red
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  @IBAction func checkValueCheckBox(_ sender: CheckBox) {
    self.delegate.checkAgreementCheckBox(sender.isChecked)
  }
  
  @IBAction func buttonDidTap(_ sender: Any) {
    self.delegate.goToPrivacy()
  }
}
