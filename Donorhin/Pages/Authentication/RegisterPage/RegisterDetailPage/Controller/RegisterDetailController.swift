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
  var pickerToolBar: UIToolbar!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        FormBuilder().getItemsForRegisterDetail { (formItems) in
            self.formItems = formItems
        }
        self.title = "Data Personal"
        self.generalPicker.delegate = self
        self.generalPicker.dataSource = self
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.datePicker.maximumDate = Date()
        pickerToolBar = UIToolbar()
        pickerToolBar.isTranslucent = true
        pickerToolBar.sizeToFit()
        pickerToolBar.tintColor = #colorLiteral(red: 0.3568627451, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
//        let cancelButton = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(pickerCancelBtnPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(pickerDoneBtnPressed))
        pickerToolBar.setItems([flexibleSpace, doneButton], animated: false)
        self.view.backgroundColor = Colors.backgroundView
        loadFormTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBar(show: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setTabBar(show: true)
    }
    
    private func setTabBar(show: Bool){
        if show {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 1
            }
        }
        else {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 0
            }
        }
    }
  
  @objc func pickerDoneBtnPressed() {
      self.formTableView.reloadData()
      closePickerView()
  }
  
  @objc func pickerCancelBtnPressed() {
    self.formTableView.reloadData()
    view.endEditing(true)
    for textField in self.view.subviews where textField is UITextField {
      textField.resignFirstResponder()
    }
    view.gestureRecognizers?.removeLast()
  }
  
  func closePickerView() {
      view.endEditing(true)
      for textField in self.view.subviews where textField is UITextField {
          textField.resignFirstResponder()
      }
      view.gestureRecognizers?.removeLast()
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
