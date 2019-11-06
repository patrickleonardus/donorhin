//
//  TrackerController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 06/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class TrackerController : UIViewController {
    
    
    @IBOutlet weak var trackerTableView: UITableView!
    let cellId = "cellId"
    var bloodRequestData : [BloodRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerTableView.delegate = self
        trackerTableView.dataSource = self
        
    trackerTableView.register(TrackerDonorTableViewCell.self, forCellReuseIdentifier: cellId)
        
        DummyData().getBloodRequest { (bloodRequests) in
            bloodRequstData = bloodRequests
        }
    }
}
