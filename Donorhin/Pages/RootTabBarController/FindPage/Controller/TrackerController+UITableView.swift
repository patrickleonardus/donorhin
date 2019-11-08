//
//  TrackerController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension TrackerController : UITableViewDelegate {
    
}

extension TrackerController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "trackerCell", for: indexPath) as? TrackerDonorTableViewCell
        //masukin datanya
        guard let data = stepItems?[indexPath.row] else {fatalError()}
        
        cell?.informationText?.text = data.description
        cell?.buttonText.setTitle(data.buttonStr, for: .normal)
        
        switch data.status {
        case .onGoing?: cell?.setupView(status: .onGoing, number: 0)
            break
        case .toDo?: cell?.setupView(status: .toDo, number: 0)
            break
        case .done?: cell?.setupView(status: .done, number: 0)
            break
        case .none:
            break
        }
        
        return cell!
    }

}
