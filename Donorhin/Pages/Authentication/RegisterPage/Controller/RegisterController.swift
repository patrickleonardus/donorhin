//
//  RegisterController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class RegisterController : UIViewController{
  var userCredentials:[String:String] = [:]
    @IBOutlet weak var formTableView: UITableView!
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FormBuilder().getItemsForRegister { (formItems) in
            self.formItems = formItems
        }
        self.view.backgroundColor = Colors.backgroundView
        loadFormTable()
    }
    
    func loadFormTable(){
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.register(UINib(nibName: "FormCustomCell", bundle: nil), forCellReuseIdentifier: "formCell")
        formTableView.register(UINib(nibName: "ButtonViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        formTableView.register(UINib(nibName: "ErrorMessageViewCell", bundle: nil), forCellReuseIdentifier: "errorMsgCell")
        formTableView.tableFooterView = UIView()
        formTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.title = "Daftar"
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "goToPersonalData" {
        let destinationVC = segue.destination as! RegisterDetailController
        destinationVC.userCredentials = self.userCredentials
      }
    }
    
    func validationCredential(email: String, password: String, confirmPassword: String) -> Bool{
        guard let errorCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ErrorMessageTableViewCell else {fatalError()}
        guard let emailCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell else {fatalError()}
        guard let passCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FormTableViewCell else {fatalError()}
        guard let confirmPassCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FormTableViewCell else {fatalError()}
      if email == "" || password == "" || confirmPassword == ""{
        DispatchQueue.main.async {
            errorCell.errorMsg.isHidden = false
            emailCell.shake()
            passCell.shake()
            confirmPassCell.shake()
            passCell.formTextField.redPlaceholder()
            confirmPassCell.formTextField.redPlaceholder()
            emailCell.formTextField.redPlaceholder()
            errorCell.errorMsg.text = "*Email, password atau konfirmasi password harus diisi"
        }
//        let alert = UIAlertController(title: "Peringatan", message: "email, password, and confirm harus diisi", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        return false
      }
      
      if !self.isValidEmail(email) {
//        let alert = UIAlertController(title: "Peringatan", message: "Format email tidak valid", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            errorCell.errorMsg.isHidden = false
            emailCell.shake()
            emailCell.formTextField.redPlaceholder()
            errorCell.errorMsg.text = "*Format email tidak valid"
        }
        return false
      }
      
      if password != confirmPassword {
//        let alert = UIAlertController(title: "Peringatan", message: "Password tidak sesuai dengan konfirmasi password", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            errorCell.errorMsg.isHidden = false
            passCell.shake()
            passCell.formTextField.redPlaceholder()
            confirmPassCell.formTextField.redPlaceholder()
            confirmPassCell.shake()
            errorCell.errorMsg.text = "*Password tidak sesuai dengan konfirmasi password"
        }
        return false
      }
        DispatchQueue.main.async {
            errorCell.errorMsg.isHidden = true
        }
      return true
    }
  
  private func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
    
}

//class CheckBox: UIButton {
//    // Images
//    let checkedImage = UIImage(named: "checkbox_isChecked")! as UIImage
//    let uncheckedImage = UIImage(named: "checkbox_isNotChecked")! as UIImage
//
//    // Bool property
//    var isChecked: Bool = false {
//        didSet{
//            if isChecked == true {
//                self.setImage(checkedImage, for: UIControl.State.normal)
//            } else {
//                self.setImage(uncheckedImage, for: UIControl.State.normal)
//
//        }
//    }
//
//    override func awakeFromNib() {
//        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
//        self.isChecked = false
//    }
//
//    @objc func buttonClicked(sender: UIButton) {
//        if sender == self {
//            isChecked = !isChecked
//        }
//    }
//}
