//
//  LabelWithTextFieldTableViewCell.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 19/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LabelWithTextFieldTableViewCell: UITableViewCell{
  @IBOutlet weak var label: UILabel!
  @IBOutlet  weak var textField: UITextField!
  
  
  var chosenDate : Date?
  
  var dateList : [Date]? = [] {
    didSet {
      print (dateList)
    }
  }
  
  
  lazy var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "id-ID")
      formatter.dateFormat = "dd MMM yyyy"
      return formatter
  }()
  
  lazy var datePicker : UIDatePicker = {
    let picker = UIDatePicker()
    picker.locale = Locale(identifier: "id-ID")
    picker.backgroundColor = .white
    picker.datePickerMode = .date
    picker.minimumDate = Date()
    picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
    return picker
  }()
  
  @objc private func datePickerChanged(_ sender : UIDatePicker) {
    self.textField.text = dateFormatter.string(from: sender.date)
    dateList?.append(sender.date)
  }

  //MARK:- Override View
  override func awakeFromNib() {
    super.awakeFromNib()
    self.textField.inputView = self.datePicker
    
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
