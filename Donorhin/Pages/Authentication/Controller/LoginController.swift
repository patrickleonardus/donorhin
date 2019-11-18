//
//  LoginController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class LoginController : UIViewController {
    
    @IBOutlet weak var formTableView: UITableView!
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    var email:String?
    var password:String?
    
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
    
    func validationCredential(email: String?, password: String?) {
        
    }
}
