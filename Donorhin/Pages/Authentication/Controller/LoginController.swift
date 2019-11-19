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
        formTableView.register(UINib(nibName: "TwoButtonCell", bundle: nil), forCellReuseIdentifier: "twoButtonCell")
        formTableView.tableFooterView = UIView()
        formTableView.showsVerticalScrollIndicator = false
    }
    
    @objc func login(){
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @objc func goToFindWithoutLogin(){
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @objc func goToRegister(){
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    
    
    func setNavBarTitle() {
        navigationItem.title =  "Masuk"
    }
    
    func validationCredential(email: String, password: String) {
        DataFetcher().getUserDataByEmail(email: email, password: password){(userModel) in
            guard userModel != nil else {
                print("email or password not valid")
                return
            }
            print("Processing...")
            UserDefaults.standard.set(userModel?.email, forKey: "email")
            UserDefaults.standard.set(userModel?.password, forKey: "password")
            UserDefaults.standard.set(userModel?.name, forKey: "name")
            UserDefaults.standard.set(userModel?.bloodType, forKey: "blood_type")
            UserDefaults.standard.set(userModel?.birthDate, forKey: "birth_date")
            UserDefaults.standard.set(userModel?.gender, forKey: "gender")
            UserDefaults.standard.set(userModel?.isVerified, forKey: "isVerified")
            UserDefaults.standard.set(userModel?.lastDonor, forKey: "last_donor")
            //convert CLLocation to NSData
            UserDefaults.standard.set(userModel?.location, forKey: "locationData")
            UserDefaults.standard.set(userModel?.imageData, forKey: "image")
            UserDefaults.standard.set(userModel?.donorStatus, forKey: "donor_status")
            print("Data saved to user default...")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }
}
