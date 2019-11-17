//
//  FormController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FormController: UIViewController{
    
    @IBOutlet weak var personalTableView: UITableView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var agreementSwitch: UISwitch!
    
    
    var formQuestionData : [FormQuestionNameModel]?
    var formPlaceholderData : [FormQuestionPlaceholderModel]?
    var formBloodType : [FormBloodTypeModel]?
    
    var viewValidationDelegate : ControlValidationViewDelegate?
    
    var submitBarButton : UIBarButtonItem?
    
    var patientName: String?
    var patientHospital: String?
    var patientBloodType: String?
    var patientDueDate: String?
    var patientBloodAmount: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        handleAgreement()
        handleKeyboard()

        FormQuestionData().getFormQuestion { (formQuestionData) in
            self.formQuestionData = formQuestionData
        }
        
        FormQuestionData().getFormPlaceholder { (formPlaceholderData) in
            self.formPlaceholderData = formPlaceholderData
        }
        
        FormBloodType().getBloodType { (formBloodType) in
            self.formBloodType = formBloodType
        }
        
    }
    
    //MARK: - Setup UI
    
    func setNavBar(){
        let cancel = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(cancelAction))
        submitBarButton = UIBarButtonItem(title: "Konfirmasi", style: .done, target: self, action: #selector(submitAction))
        
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = submitBarButton
        
        submitBarButton?.isEnabled = false
    }
    
    func handleAgreement(){
        agreementLabel.text = "Saya sudah mengajukan surat permintaan darah ke PMI"
    }
    
    func handleKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Handle date picker
    
    @objc func showDatePicker(sender: UITextField){
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        if let cell = detailTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as? LongLabelAndTextCell {
            cell.secondTextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    //MARK: - Handle validation
    
    func checkValidity(){
        
        if (patientName != nil &&
            patientHospital != nil &&
            patientBloodType != nil &&
            patientDueDate != nil &&
            patientBloodAmount != nil){
            
            submitBarButton?.isEnabled = true
            
        }
        
        else {
            submitBarButton?.isEnabled = false
        }
        
    }
    
    //MARK: - Action func
    
    @objc func cancelAction(){
        
        let alert = UIAlertController(title: "Peringatan", message: "Apakah anda yakin ingin membatalkan pengisian form surat darah?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tidak", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ya, Batalkan Pengisian Form Darah", style: .destructive, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true)
    }
    
    @objc func submitAction(){
        
        if !agreementSwitch.isOn {
            let alert = UIAlertController(title: "Peringatan", message: "Anda harus mengajukan surat permintaan darah ke PMI sebelum melakukan pencarian darah", preferredStyle: .alert)
            let submit = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(submit)
            self.present(alert,animated: true)
        }
        
        else if agreementSwitch.isOn {
            self.dismiss(animated: true, completion: nil)
            viewValidationDelegate?.didRequestData()
        }
        
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    
}

