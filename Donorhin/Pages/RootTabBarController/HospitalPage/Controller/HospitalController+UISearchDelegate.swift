//
//  HospitalController+UISearchDelegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension HospitalController : UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searching = true
        
        guard !searchText.isEmpty else {
            hospitalListFilter = hospitalList
            tableView.reloadData()
            return
        }
        
        hospitalListFilter = hospitalList!.filter({ (hospital) -> Bool in
            (hospital.name?.lowercased().contains(searchText.lowercased()))!
        })
        
        if hospitalListFilter?.count == 0 {
            viewValidation.alpha = 1
        }
        else {
            viewValidation.alpha = 0
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hospitalListFilter = hospitalList
        viewValidation.alpha = 0
        tableView.reloadData()
    }
    
}
