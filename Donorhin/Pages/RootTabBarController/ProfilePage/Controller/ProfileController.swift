//
//  ProfileController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
class ProfileController: UIViewController, TextProtocol {
    
    //MARK: Outlet
    @IBOutlet weak var profileTableView: UITableView!
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
    let profileCells = FirstCell()
    lazy var profileCell = profileTableView.cellForRow(at: IndexPath(row:0, section: 0)) as? FirstCell
    lazy var genderCell = profileTableView.cellForRow(at: IndexPath(row:0, section: 1)) as? SecondCell
    lazy var birthDateCell = profileTableView.cellForRow(at: IndexPath(row:1, section: 1)) as? SecondCell
    lazy var bloodTypeCell = profileTableView.cellForRow(at: IndexPath(row:2, section: 1)) as? SecondCell
    lazy var lastDonorCell = profileTableView.cellForRow(at: IndexPath(row:3, section: 1)) as? SecondCell


    
    //MARK: View Did Load
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
    }
    
    //MARK: Set Gender Value
    func setGenderValue(_ genderCell: SecondCell) ->  Int {
        switch genderCell.profileTextField.text {
        case "Perempuan":
            return 0
        default:
            return 1
        }
    }
    
    //MARK: Dismiss Keyboard
    @objc func doneButtonPressed() {
        view.endEditing(true)
    }
    
    //MARK: Set Date Format
    func setDate(_ textView:UITextView){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if textView.text != "" {
        self.datePicker.setDate(dateFormatter.date(from: textView.text)!, animated: true)
        }
    }
    
    //MARK: Save Data
    func saveData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        //save ke userdefaults sama cloudkit
        view.endEditing(true)
        
        let valueGender = setGenderValue(genderCell!)
        let lastDonorDate  = dateFormatter.date(from: (lastDonorCell?.profileTextField.text ?? "-"))
        let birthDate  = dateFormatter.date(from: (birthDateCell?.profileTextField.text ?? "-"))
        
        //get recordName from userdefaults
        guard let recordName = UserDefaults.standard.value(forKey: "currentUser") as? String else{
            return
        }
        let recordId = CKRecord.ID(recordName: recordName)
        
        let package : [String:Any] = ["name": profileCell?.nameTextField.text, "email": profileCell?.emailTextField.text,"last_donor": lastDonorDate, "birth_date":birthDate,"gender":valueGender, "blood_type":bloodTypeCell?.profileTextField.text]
        
        //MARK: Saving To CloudKit
        Helper.updateToDatabase(keyValuePair: package, recordID: recordId)
        
        //MARK: Saving To User Defaults
        UserDefaults.standard.set(profileCell?.nameTextField.text, forKey: "name")
        UserDefaults.standard.set(profileCell?.emailTextField.text, forKey: "email")
            UserDefaults.standard.set(valueGender, forKey: "gender")
        UserDefaults.standard.set(bloodTypeCell?.profileTextField.text, forKey: "blood_type")
            UserDefaults.standard.set(lastDonorDate, forKey: "last_donor")
            UserDefaults.standard.set(birthDate, forKey: "birth_date")
    }
    
    //MARK: Set Date Changed
    @objc func dateChanged (datePicker : UIDatePicker, activeTF : UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        if birthDateCell?.profileTextField.isFirstResponder ?? false {
            birthDateCell?.profileTextField.text = dateFormatter.string(from: datePicker.date)
        }
        if lastDonorCell?.profileTextField.isFirstResponder ?? false {
          lastDonorCell?.profileTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    //MARK: Set Date Picker
    @objc func dateSetup(datePicker : UIDatePicker, activeTF : UITextField){
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd MMMM yyyy"
          
        if birthDateCell?.profileTextField.isFirstResponder ?? false {
            datePicker.setDate(dateFormatter.date(from: (birthDateCell?.profileTextField.text!)!)!, animated: true)
          }
        if lastDonorCell?.profileTextField.text != "" {
            if lastDonorCell?.profileTextField.isFirstResponder ?? false {
                datePicker.setDate( dateFormatter.date(from: lastDonorCell!.profileTextField.text!)!, animated: true)
          }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setValidation()
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: Set Up UI
    private func setupUI(){
        profileTableView.tableFooterView = UIView()
        setNavigationButton()
      
      if checkLogin != nil {
        setEditButton()
      }

        profileCell?.nameTextField.isEnabled = false
        profileCell?.emailTextField.isEnabled = false
        genderCell?.profileTextField.isEnabled = false
        birthDateCell?.profileTextField.isEnabled = false
        bloodTypeCell?.profileTextField.isEnabled = false
        lastDonorCell?.profileTextField.isEnabled = false
      
        profileCell?.nameTextField.textColor = Colors.gray
        profileCell?.emailTextField.textColor = Colors.gray
        genderCell?.profileTextField.textColor = Colors.gray
        birthDateCell?.profileTextField.textColor = Colors.gray
        bloodTypeCell?.profileTextField.textColor = Colors.gray
        lastDonorCell?.profileTextField.textColor = Colors.gray
        
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                self.bloodTypePicker.delegate = self
                self.bloodTypePicker.dataSource = self
                self.genderTypePicker.delegate = self
                self.genderTypePicker.dataSource = self
                self.datePicker.datePickerMode = .date
                self.datePicker.maximumDate = Date()
        self.datePicker.addTarget(self, action: #selector(dateSetup), for: .editingDidBegin)
                self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    
                pickerToolBar = UIToolbar()
                pickerToolBar.isTranslucent = true
                pickerToolBar.sizeToFit()
                pickerToolBar.tintColor = #colorLiteral(red: 0.7071222663, green: 0, blue: 0.04282376915, alpha: 1)
                let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let doneButton = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(doneButtonPressed))
                pickerToolBar.setItems([flexibleSpace, doneButton], animated: false)
                self.view.backgroundColor = Colors.backgroundView
    }
    
    //MARK: Set Left Bar Button (Done)
    private func setNavigationButton(){
        let doneButton = UIBarButtonItem(title: "Selesai", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    //MARK: Set Right Bar Button (Edit)
    func setEditButton(){
        editButton = UIBarButtonItem(title: "Ubah", style: .done, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }
    
    //MARK: Set Edit Mode View
    @objc func editButtonPressed() {

      guard let logoutButton = profileTableView.cellForRow(at: IndexPath(row: 0, section: 2))  as? ThirdCell else {fatalError()}
      
        if editMode == false {
            editMode = true
            editButton?.title = "Simpan"
            profileCell?.nameTextField.isEnabled = true
            profileCell?.emailTextField.isEnabled = true
            genderCell?.profileTextField.isEnabled = true
            birthDateCell?.profileTextField.isEnabled = true
            bloodTypeCell?.profileTextField.isEnabled = true
            lastDonorCell?.profileTextField.isEnabled = true
            
            profileCell?.nameTextField.textColor = UIColor.black
            profileCell?.emailTextField.textColor = UIColor.black
            genderCell?.profileTextField.textColor = UIColor.black
            birthDateCell?.profileTextField.textColor = UIColor.black
            bloodTypeCell?.profileTextField.textColor = UIColor.black
            lastDonorCell?.profileTextField.textColor = UIColor.black
          
          UIView.animate(withDuration: 0.2) {
            logoutButton.alpha = 0
          }
          
        } else {
            saveData()
            editMode = false
            editButton?.title = "Ubah"
            profileCell?.nameTextField.isEnabled = false
            profileCell?.emailTextField.isEnabled = false
            genderCell?.profileTextField.isEnabled = false
            birthDateCell?.profileTextField.isEnabled = false
            bloodTypeCell?.profileTextField.isEnabled = false
            lastDonorCell?.profileTextField.isEnabled = false
            profileCell?.nameTextField.textColor = Colors.gray
            profileCell?.emailTextField.textColor = Colors.gray
            genderCell?.profileTextField.textColor = Colors.gray
            birthDateCell?.profileTextField.textColor = Colors.gray
            bloodTypeCell?.profileTextField.textColor = Colors.gray
            lastDonorCell?.profileTextField.textColor = Colors.gray
          
          UIView.animate(withDuration: 0.2) {
            logoutButton.alpha = 1
          }
        }
    }
    
    //MARK: Validation Login
    private func setValidation(){
      
        if checkLogin != nil {
            viewValidation.alpha = 0
        }
        else if checkLogin == nil {
            viewValidation.alpha = 1
        }
        
    }
    
    //MARK: -Action dissmiss modal view
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
          self.inboxDelegate?.performLogin()
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

        self.profileTableView.contentInset = contentInsets
        self.profileTableView.scrollIndicatorInsets = contentInsets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height

         if highlightedCell != nil{
            if !aRect.contains(self.highlightedCell!.frame.origin) {
                self.profileTableView.scrollRectToVisible(highlightedCell!.frame, animated: true)
            }
         }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.profileTableView.contentInset = contentInsets
        self.profileTableView.scrollIndicatorInsets = contentInsets
    }
}
