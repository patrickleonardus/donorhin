//
//  LabelAndTextFieldCell.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LabelAndTextFieldCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var answer: UITextField!
    
    var tableViewRow = 0
    var tableViewSection = 0
    
    //MARK: - Initialize data jawaban user
    var titleEvent: String?
    var descEvent: String?
    var locEvent: String?
    var startEvent: String?
    var endEvent: String?
    var nameEvent: String?
    var phoneEvent: String?

    var delegate : AnswerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.answer.delegate = self
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.answer.text = nil
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if answer.text!.isEmpty {
            delegate?.didFilled(cell: self, isFilled: false)
        }
        else if !answer.text!.isEmpty{
            delegate?.didFilled(cell: self, isFilled: true)
            
            if tableViewSection == 0 {
                if tableViewRow == 0 {
                    titleEvent = textField.text
                    delegate?.getTitle(cell: self, data: titleEvent!)
                }
                else if tableViewRow == 1 {
                    descEvent = textField.text
                    delegate?.getDesc(cell: self, data: descEvent!)
                }
            }
            else if tableViewSection == 1 {
                if tableViewRow == 0 {
                    locEvent = textField.text
                    delegate?.getloc(cell: self, data: locEvent!)
                }
                else if tableViewRow == 1 {
                    startEvent = textField.text
                    delegate?.getStart(cell: self, data: startEvent!)
                }
                else if tableViewRow == 2 {
                    endEvent = textField.text
                    delegate?.getEnd(cell: self, data: endEvent!)
                }
            }
            else if tableViewSection == 2 {
                if tableViewRow == 0 {
                    nameEvent = textField.text
                    delegate?.getName(cell: self, data: nameEvent!)
                }
                else if tableViewRow == 1 {
                    phoneEvent = textField.text
                    delegate?.getPhone(cell: self, data: phoneEvent!)
                }
            }
            
        }
    }
}

protocol AnswerDelegate {
    func didFilled(cell: LabelAndTextFieldCell, isFilled: Bool)
    func getTitle(cell: LabelAndTextFieldCell, data: String)
    func getDesc(cell: LabelAndTextFieldCell, data: String)
    func getloc(cell: LabelAndTextFieldCell, data: String)
    func getStart(cell: LabelAndTextFieldCell, data: String)
    func getEnd(cell: LabelAndTextFieldCell, data: String)
    func getName(cell: LabelAndTextFieldCell, data: String)
    func getPhone(cell: LabelAndTextFieldCell, data: String)
}
