//
//  TrackerController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 06/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class TrackerController : UIViewController {
    
    @IBOutlet weak var TrackerTableView: UITableView!
    
    let cellId = 1
    var bloodRequestData : [BloodRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TrackerTableView.delegate = self
        //TrackerTableView.dataSource = self
        
    }
}
