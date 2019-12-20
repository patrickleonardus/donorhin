//
//  UIDatePicker + Stylign.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 17/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension UIDatePicker {
   func styling() {
      self.backgroundColor = .white
      self.tintColor = Colors.red
   }
}

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
  
  
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = Colors.red
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
