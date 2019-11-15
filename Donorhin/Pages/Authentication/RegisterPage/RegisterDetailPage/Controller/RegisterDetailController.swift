//
//  RegisterDetailController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class RegisterDetailController : UIViewController {
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    
    @IBOutlet weak var formTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FormBuilder().getItemsForRegisterDetail { (formItems) in
            self.formItems = formItems
        }
        self.view.backgroundColor = Colors.backgroundView
        loadFormTable()
    }
    
    func loadFormTable(){
           formTableView.delegate = self
           formTableView.dataSource = self
           formTableView.register(UINib(nibName: "FormCustomCell", bundle: nil), forCellReuseIdentifier: "formCell")
           formTableView.tableFooterView = UIView()
           formTableView.showsVerticalScrollIndicator = false
    }
       
}
