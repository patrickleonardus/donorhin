//
//  RegisterController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class RegisterController : UIViewController{
  var userCredentials:[String:String] = [:]
    @IBOutlet weak var formTableView: UITableView!
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    var activeCell : FormTableViewCell?
    var isAvalaible : Bool?
    
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
            self.removeSpinner()
            errorCell.errorMsg.isHidden = false
            emailCell.shake()
            passCell.shake()
            confirmPassCell.shake()
            passCell.formTextField.redPlaceholder()
            confirmPassCell.formTextField.redPlaceholder()
            emailCell.formTextField.redPlaceholder()
            errorCell.errorMsg.text = "*Pastikan seluruh form telah terisi"
        }
        return false
      }
      
      else if !self.isValidEmail(email) {
        DispatchQueue.main.async {
            self.removeSpinner()
            errorCell.errorMsg.isHidden = false
            emailCell.shake()
            emailCell.formTextField.redPlaceholder()
            errorCell.errorMsg.text = "*Format email tidak valid"
        }
        return false
      }
      
      else if password != confirmPassword {
        DispatchQueue.main.async {
            self.removeSpinner()
            errorCell.errorMsg.isHidden = false
            passCell.shake()
            passCell.formTextField.redPlaceholder()
            confirmPassCell.formTextField.redPlaceholder()
            confirmPassCell.shake()
            errorCell.errorMsg.text = "*Kata sandi tidak sesuai dengan konfirmasi kata sandi"
        }
        return false
      }
      return true
    }
    
  //MARK: - Check to database existing email
  
  func checkExistUserEmail(email: String, completionHandler: @escaping (Bool)->Void) {
    let ckQuery = CKQuery(recordType: "Account", predicate: NSPredicate(format: "email = %@", email))
    Helper.getAllData(ckQuery) { (result) in
      if let result = result {
        if result.count > 0 {
          completionHandler(false)
        }
        else {
          completionHandler(true)
        }
      }
      else {
        completionHandler(true)
      }
    }
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let emailCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell else {return}
        guard let passCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FormTableViewCell else {return}
        guard let repassCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? FormTableViewCell else {return}
        guard let errorCell = self.formTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ErrorMessageTableViewCell else {return}
              DispatchQueue.main.async {
                emailCell.formTextField.defaultPlaceholder()
                passCell.formTextField.defaultPlaceholder()
                repassCell.formTextField.defaultPlaceholder()
                errorCell.errorMsg.isHidden = true
                self.removeSpinner()
            }
    }
    
  private func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
  }
    
}
