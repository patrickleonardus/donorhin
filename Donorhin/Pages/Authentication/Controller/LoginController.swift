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
    
    @IBAction func goToRegister(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func goToCari(_ sender: Any) {
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
    }
    
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
        formTableView.tableFooterView = UIView()
        formTableView.showsVerticalScrollIndicator = false
    }
    
    func setNavBarTitle() {
        navigationItem.title =  "Masuk"
    }
    
}
