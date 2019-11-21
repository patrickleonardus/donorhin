//
//  RegisterDetailController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
class RegisterDetailController : UIViewController{
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    var userCredentials:[String:String] = [:]
    var detailUserCredentials:[String:String] = [:]
    @IBOutlet weak var formTableView: UITableView!
    let generalPicker = UIPickerView()
    let database = CKContainer.default().publicCloudDatabase
    let datePicker = UIDatePicker()
    let gender = ["Pria","Wanita"]
    let bloodType = ["A-","A+","B-","B+","O-","O+","AB-","AB+"]
  

  
    override func viewDidLoad() {
        super.viewDidLoad()
        FormBuilder().getItemsForRegisterDetail { (formItems) in
            self.formItems = formItems
        }
        self.generalPicker.delegate = self
        self.generalPicker.dataSource = self
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.view.backgroundColor = Colors.backgroundView
        loadFormTable()
    }
  
  @objc func dateChanged (datePicker : UIDatePicker, activeTF : UITextField) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd MMM y"
      let birthDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! FormTableViewCell
      let lastDonorDateCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! FormTableViewCell
    
      if birthDateCell.formTextField.isFirstResponder {
        birthDateCell.formTextField.text = dateFormatter.string(from: datePicker.date)
      }
      if lastDonorDateCell.formTextField.isFirstResponder {
        lastDonorDateCell.formTextField.text = dateFormatter.string(from: datePicker.date)
      }
  }
    
    func loadFormTable(){
           formTableView.delegate = self
           formTableView.dataSource = self
           formTableView.register(UINib(nibName: "FormCustomCell", bundle: nil), forCellReuseIdentifier: "formCell")
           formTableView.register(UINib(nibName: "AgreementViewCell", bundle: nil), forCellReuseIdentifier: "agreementCell")
           formTableView.register(UINib(nibName: "ButtonViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
           formTableView.tableFooterView = UIView()
           formTableView.showsVerticalScrollIndicator = false
    }
}

extension RegisterDetailController: UITextFieldDelegate{
  func textFieldDidBeginEditing(_ textField: UITextField) {
    generalPicker.reloadAllComponents()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
