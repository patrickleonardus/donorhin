//
//  HospitalController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadData()
//        setupTableView()
        setupSearchBar()
        setupUI()
        
    }
    
    func setupUI(){
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
    
    func setupTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadData()
    }
    
    private func loadData(){
        
        HospitalList().getHospitalList { (hospitalList) in
            self.hospitalList = hospitalList
            print(hospitalList)
        }
        
        DispatchQueue.main.async {
            
            HospitalList().getHospitalList { (hospitalList) in
                self.hospitalList = hospitalList
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToForm" {
            let destination = segue.destination as! FormController
            destination.patientHospital = choosenHospital
        }
        
    }

}
