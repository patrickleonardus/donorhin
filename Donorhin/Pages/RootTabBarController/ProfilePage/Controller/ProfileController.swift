//
//  ProfileController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewValidation: CustomMainView!
    
    //MARK: Properties
    let customPicker = UIPickerView()
    let datePicker = UIDatePicker()
    var delegate : MoveToLogin?
    var editMode = false
    var editButton : UIBarButtonItem?
    private var picker: UIPickerView?
    let bloodType = ["A-","A+","B-","B+","O-","O+","AB-","AB+", "Belum Diketahui"]
    let gender = ["Laki-laki","Perempuan"] //for picker view
    var pickerToolBar: UIToolbar!

    var user : Profile?
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        ProfileDataFetcher().getProfileFromUserDefaults { (profileData) in
            self.user = profileData
        }
        self.customPicker.delegate = self as? UIPickerViewDelegate
        self.customPicker.dataSource = self as? UIPickerViewDataSource
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.datePicker.maximumDate = Date()
        pickerToolBar = UIToolbar()
        pickerToolBar.isTranslucent = true
        pickerToolBar.sizeToFit()
        pickerToolBar.tintColor = #colorLiteral(red: 0.7071222663, green: 0, blue: 0.04282376915, alpha: 1)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(pickerDoneBtnPressed))
        pickerToolBar.setItems([flexibleSpace, doneButton], animated: false)
        self.view.backgroundColor = Colors.backgroundView
    }
    
    @objc func pickerDoneBtnPressed() {
        self.tableView.reloadData()
        closePickerView()
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
        guard
        let birthDateCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? SecondCell,
          let lastDonorDateCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as? SecondCell else {return}
      
        if birthDateCell.profileTextField.isFirstResponder {
          birthDateCell.profileTextField.text = dateFormatter.string(from: datePicker.date)
        }
        if lastDonorDateCell.profileTextField.isFirstResponder {
          lastDonorDateCell.profileTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setValidation()
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: Set Up UI
    private func setupUI(){
        tableView.tableFooterView = UIView()
        setNavigationButton()
        setEditButton()
    }
    
    private func setNavigationButton(){
        let doneButton = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    func setEditButton(){
        editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editButtonPressed() {
        guard let genderCell = tableView.cellForRow(at: IndexPath(row:0, section: 1)) as? SecondCell else{fatalError()}
        guard let birthDateCell = tableView.cellForRow(at: IndexPath(row:1, section: 1)) as? SecondCell else{fatalError()}
        guard let bloodTypeCell = tableView.cellForRow(at: IndexPath(row:2, section: 1)) as? SecondCell else{fatalError()}
        guard let lastDonorCell = tableView.cellForRow(at: IndexPath(row:3, section: 1)) as? SecondCell else{fatalError()}
        
        if editMode == false {
            editMode = true
            editButton?.title = "Done"
            genderCell.profileTextField.isEnabled = true
            birthDateCell.profileTextField.isEnabled = true
            bloodTypeCell.profileTextField.isEnabled = true
            lastDonorCell.profileTextField.isEnabled = true
        } else {
            editMode = false
            editButton?.title = "Edit"
            genderCell.profileTextField.isEnabled = false
            birthDateCell.profileTextField.isEnabled = false
            bloodTypeCell.profileTextField.isEnabled = false
            lastDonorCell.profileTextField.isEnabled = false
        }
    }
    
    private func setValidation(){
        
        let checkLogin = UserDefaults.standard.string(forKey: "currentUser")
        if checkLogin != nil {
            viewValidation.alpha = 0
        }
        else if checkLogin == nil {
            viewValidation.alpha = 1
        }
        
    }
    
    
    
    
    //MARK: -Action
    // dissmiss modal view
    @objc private func doneAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logoutAction(){
       let action = UIAlertController(title: "Anda akan logout", message: "Apakah anda yakin akan logout?", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            self.logout()
        }))
        action.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(action,animated: true)
    }
    
    func logout(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.performLogin()
        }
    }
    
    
}

