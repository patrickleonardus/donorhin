//
//  LabelAndTextViewCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LabelAndTextViewCell: UITableViewCell, UITextViewDelegate {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var answer: UITextView!
  
  var tableViewRow = 0
  var tableViewSection = 0
  
  var descEvent: String?

  var delegate : AnswerDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      self.answer.delegate = self
      answer.text = "Tambahkan Deskripsi Acara"
      self.answer.textColor = Colors.gray_disabled
      
    }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.answer.text = nil
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if self.answer.textColor == Colors.gray_disabled {
      answer.text = nil
      answer.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    
    if answer.text.isEmpty {
      answer.text = "Tambahkan Deskripsi Acara"
      answer.textColor = Colors.gray_disabled
    }
    
    else {
      if tableViewSection == 0 {
        if tableViewRow == 1 {
          descEvent = textView.text
          delegate?.getDesc(cell: self, data: descEvent!)
        }
      }
    }
  }
}
