//
//  LoginController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CoreLocation

class LoginController : UIViewController {
    
    @IBOutlet weak var formTableView: UITableView!
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        FormBuilder().getItemsForLogin { (formItems) in
            self.formItems = formItems
        }
        self.view.backgroundColor = Colors.backgroundView
        loadFormTable()
        setNavBarTitle()
    }
    
    func loadFormTable(){
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.register(UINib(nibName: "FormCustomCell", bundle: nil), forCellReuseIdentifier: "formCell")
        formTableView.register(UINib(nibName: "ButtonViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        formTableView.register(UINib(nibName: "ErrorMessageViewCell", bundle: nil), forCellReuseIdentifier: "errorMsgCell")
        formTableView.register(UINib(nibName: "TwoButtonCell", bundle: nil), forCellReuseIdentifier: "twoButtonCell")
        formTableView.tableFooterView = UIView()
        formTableView.showsVerticalScrollIndicator = false
    }
    
    @objc func goToFindWithoutLogin(){
        navigationController?.navigationBar.isHidden = true
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @objc func goToRegister(){
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    func setNavBarTitle() {
        navigationItem.title =  "Masuk"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func validationCredential(email: String, password: String) {
        guard let buttonCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? ErrorMessageTableViewCell else {return}
        
        DataFetcher().getUserDataByEmail(email: email, password: password){(userModel) in
            guard userModel != nil else {
                DispatchQueue.main.async {
                    print("*Email or password not valid")
                    buttonCell.errorMsg.isHidden = false
                    buttonCell.errorMsg.text = "*Email atau password tidak valid"
                }
                return
            }
            print("Processing...")
            UserDefaults.standard.set(userModel?.email, forKey: "email")
            UserDefaults.standard.set(userModel?.password, forKey: "password")
            UserDefaults.standard.set(userModel?.name, forKey: "name")
            UserDefaults.standard.set(userModel?.bloodType.rawValue, forKey: "blood_type")
            UserDefaults.standard.set(userModel?.birthdate, forKey: "birth_date")
            UserDefaults.standard.set(userModel?.gender.rawValue, forKey: "gender")
            UserDefaults.standard.set(userModel?.isVerified, forKey: "isVerified")
            UserDefaults.standard.set(userModel?.lastDonor, forKey: "last_donor")
            UserDefaults.standard.set(userModel?.statusDonor, forKey: "donor_status")
            print("Data saved to user default...")
            DispatchQueue.main.async {
                buttonCell.errorMsg.isHidden = true
                self.navigationController?.navigationBar.isHidden = true
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }
}
