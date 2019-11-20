//
//  HospitalController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class HospitalController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewValidation: UIView!
    
    var hospitalList : [HospitalModel]?
    var hospitalListFilter : [HospitalModel]?
    
    var searching = false
    
    var choosenHospital : String?
    
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HospitalList().getHospitalList { (hospitalList) in
            self.hospitalList = hospitalList
        }

        setupSearchBar()
        setupUI()
        
    }
    
    func setupUI(){
        tableView.tableFooterView = UIView()
        viewValidation.alpha = 0
    }
    
    func setupSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self as UISearchBarDelegate
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Ketik nama UTD"
        searchController.searchBar.isHidden = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToForm" {
            let destination = segue.destination as! FormController
            destination.patientHospital = choosenHospital
        }
        
    }

}
