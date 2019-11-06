//
//  FindController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FindController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findBloodSegmentedControl: UISegmentedControl!
    
    let cellId = "cellId"
    
    var bloodRequstData: [BloodRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(findBlood.self, forCellReuseIdentifier: cellId)
    
        DummyData().getBloodRequest { (bloodRequests) in
            self.bloodRequstData = bloodRequests
        }
        
    }
    
    @IBAction func findBloodSegmentedControlDidChange() {
        print("value changed")
    }
}


