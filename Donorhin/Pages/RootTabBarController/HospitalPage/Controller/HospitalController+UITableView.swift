//
//  HospitalController+UITableView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension HospitalController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        if !searching {
            
            if hospitalList != nil{
                guard let rows = self.hospitalList?.count else {fatalError()}
                numberOfRows = rows
            }
            
        }
        else if searching{
            guard let rows = hospitalListFilter?.count else {fatalError()}
            numberOfRows = rows
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hopitalListCell")
        
        if !searching {
            guard let data = hospitalList?[indexPath.row] else {fatalError()}
            
            cell?.textLabel?.text = data.name
            cell?.detailTextLabel?.text = data.alamat
        }
            
        else if searching {
            guard let data = hospitalListFilter?[indexPath.row] else {fatalError()}
            
            cell?.textLabel?.text = data.name
            cell?.detailTextLabel?.text = data.alamat
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !searching {
            guard let data = hospitalList?[indexPath.row] else {fatalError()}
            choosenHospital = data.name
            choosenHospitalId = data.id
            chosenHospital = data
        }
        else if searching {
            guard let data = hospitalListFilter?[indexPath.row] else {fatalError()}
            choosenHospital = data.name
            choosenHospitalId = data.id
            chosenHospital = data
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let hospital = chosenHospital, let _ = hospitalDelegate {
          self.hospitalDelegate?.selectedHospital(hospital: hospital)
          self.navigationController?.popViewController(animated: true)
        }
        
        self.performSegue(withIdentifier: "unwindToForm", sender: self)
        
    }
    
}
