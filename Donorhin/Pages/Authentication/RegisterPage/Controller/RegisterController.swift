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
        formTableView.tableFooterView = UIView()
        formTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
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
      if email == "" || password == "" || confirmPassword == ""{
        let alert = UIAlertController(title: "Peringatan", message: "email, password, and confirm harus diisi", preferredStyle: .alert)
        let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        return false
      }
      
      if !self.isValidEmail(email) {
        let alert = UIAlertController(title: "Peringatan", message: "Format email tidak valid", preferredStyle: .alert)
        let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        return false
      }
      
      if password != confirmPassword {
        let alert = UIAlertController(title: "Peringatan", message: "Password tidak sesuai dengan konfirmasi password", preferredStyle: .alert)
        let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        return false
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
