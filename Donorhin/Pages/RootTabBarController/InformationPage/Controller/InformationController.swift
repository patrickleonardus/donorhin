//
//  InformationController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class InformationController : UIViewController {
    
    @IBOutlet weak var sectionTable: UITableView!
    
    var infoItems : [InfoItems]?
    var navigationBarTitle : String? = "Info Komunitas"
    var sectionTotal : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarTitle()
        self.view.backgroundColor = Colors.backgroundView
        if sectionTotal == 2 {
        InfoData().getInfoCommunity { (infoItems) in
            self.infoItems = infoItems
        }
        }
        loadTableView()
    }
    
    func loadTableView() {
        sectionTable.delegate = self
        sectionTable.backgroundColor = Colors.backgroundView
        sectionTable.dataSource = self
        sectionTable.register(UINib(nibName: "InformationCustomCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        sectionTable.tableFooterView = UIView()
        sectionTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setNavBarTitle(){
        navigationItem.title = navigationBarTitle
    }
}
