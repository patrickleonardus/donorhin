//
//  ProfileController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
class ProfileController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewValidation: CustomMainView!
    @IBOutlet weak var belumLoginImageView: UIImageView!
    
    //MARK: Properties
    let bloodTypePicker = UIPickerView()
  let genderTypePicker = UIPickerView()
    let datePicker = UIDatePicker()
    var findDelegate : MoveToLoginFromFind?
  var donateDelegate : MoveToLoginFromDonate?
  var discoverDelegate : MoveToLoginFromDiscover?
  var inboxDelegate : MoveToLoginFromInbox?
    var editMode = false
    var editButton : UIBarButtonItem?
    private var picker: UIPickerView?
    let bloodType = ["A-","A+","B-","B+","O-","O+","AB-","AB+", "Belum Diketahui"]
    let gender = ["Laki-Laki","Perempuan"] //for picker view
    var pickerToolBar: UIToolbar!
    var highlightedCell:UITableViewCell?
    var user : Profile?
    let checkLogin = UserDefaults.standard.string(forKey: "currentUser")
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if UDDevice.widthScreen < 400 {
            
            belumLoginImageView.frame.size = CGSize.init(width: 50, height: 50)
        }
        print(UIScreen.main.bounds.size.width)
        
    ProfileDataFetcher().getProfileFromUserDefaults { (profileData) in
            self.user = profileData
        }
        self.bloodTypePicker.delegate = self
        self.bloodTypePicker.dataSource = self
      self.genderTypePicker.delegate = self
      self.genderTypePicker.dataSource = self
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.datePicker.maximumDate = Date()
        pickerToolBar = UIToolbar()
        pickerToolBar.isTranslucent = true
        pickerToolBar.sizeToFit()
        pickerToolBar.tintColor = #colorLiteral(red: 0.7071222663, green: 0, blue: 0.04282376915, alpha: 1)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(doneButtonPressed))
        pickerToolBar.setItems([flexibleSpace, doneButton], animated: false)
        self.view.backgroundColor = Colors.backgroundView
    }
    
    func setGenderValue(_ genderCell: SecondCell) ->  Int {
        switch genderCell.profileTextField.text {
        case "Perempuan":
            return 0
        default:
            return 1
        }
    }
    
    @objc func doneButtonPressed() {
        view.endEditing(true)
    }
    
    func saveData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        //save ke userdefaults sama cloudkit
        view.endEditing(true)
        guard let genderCell = tableView.cellForRow(at: IndexPath(row:0, section: 1)) as? SecondCell else{fatalError()}
        guard let birthDateCell = tableView.cellForRow(at: IndexPath(row:1, section: 1)) as? SecondCell else{fatalError()}
        guard let bloodTypeCell = tableView.cellForRow(at: IndexPath(row:2, section: 1)) as? SecondCell else{fatalError()}
        guard let lastDonorCell = tableView.cellForRow(at: IndexPath(row:3, section: 1)) as? SecondCell else{fatalError()}
        
        let valueGender = setGenderValue(genderCell)
        guard
            let lastDonorDate  = dateFormatter.date(from: lastDonorCell.profileTextField.text!),
            let birthDate  = dateFormatter.date(from: birthDateCell.profileTextField.text!) else {fatalError()}
        
        //get recordName from userdefaults
        guard let recordName = UserDefaults.standard.value(forKey: "currentUser") as? String else{
            return
        }
        let recordId = CKRecord.ID(recordName: recordName)
        
        let package : [String:Any] = ["last_donor": lastDonorDate, "birth_date":birthDate,"gender":valueGender, "blood_type":bloodTypeCell.profileTextField.text]
        //saving to cloudkit
        Helper.updateToDatabase(keyValuePair: package, recordID: recordId)
        
        //saving to user defaults
        UserDefaults.standard.set(valueGender, forKey: "gender")
        UserDefaults.standard.set(bloodTypeCell.profileTextField.text, forKey: "blood_type")
        UserDefaults.standard.set(lastDonorDate, forKey: "last_donor")
        UserDefaults.standard.set(birthDate, forKey: "birth_date")
        
    }
    
    @objc func dateChanged (datePicker : UIDatePicker, activeTF : UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
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
      
      if checkLogin != nil {
        setEditButton()
      }
      
        guard let genderCell = tableView.cellForRow(at: IndexPath(row:0, section: 1)) as? SecondCell else{fatalError()}
        guard let birthDateCell = tableView.cellForRow(at: IndexPath(row:1, section: 1)) as? SecondCell else{fatalError()}
        guard let bloodTypeCell = tableView.cellForRow(at: IndexPath(row:2, section: 1)) as? SecondCell else{fatalError()}
        guard let lastDonorCell = tableView.cellForRow(at: IndexPath(row:3, section: 1)) as? SecondCell else{fatalError()}
        genderCell.profileTextField.isEnabled = false
        birthDateCell.profileTextField.isEnabled = false
        bloodTypeCell.profileTextField.isEnabled = false
        lastDonorCell.profileTextField.isEnabled = false
      genderCell.profileTextField.textColor = Colors.gray
      birthDateCell.profileTextField.textColor = Colors.gray
      bloodTypeCell.profileTextField.textColor = Colors.gray
      lastDonorCell.profileTextField.textColor = Colors.gray
        

        
    }
    
    private func setNavigationButton(){
        let doneButton = UIBarButtonItem(title: "Selesai", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    func setEditButton(){
        editButton = UIBarButtonItem(title: "Ubah", style: .done, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editButtonPressed() {
        guard let genderCell = tableView.cellForRow(at: IndexPath(row:0, section: 1)) as? SecondCell else{fatalError()}
        guard let birthDateCell = tableView.cellForRow(at: IndexPath(row:1, section: 1)) as? SecondCell else{fatalError()}
        guard let bloodTypeCell = tableView.cellForRow(at: IndexPath(row:2, section: 1)) as? SecondCell else{fatalError()}
        guard let lastDonorCell = tableView.cellForRow(at: IndexPath(row:3, section: 1)) as? SecondCell else{fatalError()}
      guard let logoutButton = tableView.cellForRow(at: IndexPath(row: 0, section: 2))  as? ThirdCell else {fatalError()}
      
      
        if editMode == false {
            editMode = true
            editButton?.title = "Simpan"
            genderCell.profileTextField.isEnabled = true
            birthDateCell.profileTextField.isEnabled = true
            bloodTypeCell.profileTextField.isEnabled = true
            lastDonorCell.profileTextField.isEnabled = true
          genderCell.profileTextField.textColor = UIColor.black
          birthDateCell.profileTextField.textColor = UIColor.black
          bloodTypeCell.profileTextField.textColor = UIColor.black
          lastDonorCell.profileTextField.textColor = UIColor.black
          
          UIView.animate(withDuration: 0.2) {
            logoutButton.alpha = 0
          }
          
          
        } else {
            saveData()
            editMode = false
            editButton?.title = "Ubah"
            genderCell.profileTextField.isEnabled = false
            birthDateCell.profileTextField.isEnabled = false
            bloodTypeCell.profileTextField.isEnabled = false
            lastDonorCell.profileTextField.isEnabled = false
          genderCell.profileTextField.textColor = Colors.gray
          birthDateCell.profileTextField.textColor = Colors.gray
          bloodTypeCell.profileTextField.textColor = Colors.gray
          lastDonorCell.profileTextField.textColor = Colors.gray
          
          UIView.animate(withDuration: 0.2) {
            logoutButton.alpha = 1
          }
          
        }
    }
    
    private func setValidation(){
      
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
      
      UserDefaults.standard.set(true, forKey: "launchedBefore")
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        dismiss(animated: true) {
            self.findDelegate?.performLogin()
          self.donateDelegate?.performLogin()
          self.discoverDelegate?.performLogin()
        }
    }
    
    func checkGender(_ gender: String) -> Int {
      switch gender {
      case "Laki-Laki":
        return 1
      case "Perempuan":
        return 0
      default:
        return 1
      }
    }
    
    func textFieldDidBeginEditing(cell: FormTableViewCell) {
        self.highlightedCell = cell
    }

    func textFieldDidEndEditing() {
        self.highlightedCell = nil
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)

        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height

         if highlightedCell != nil{
            if !aRect.contains(self.highlightedCell!.frame.origin) {
                self.tableView.scrollRectToVisible(highlightedCell!.frame, animated: true)
            }
         }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
}
