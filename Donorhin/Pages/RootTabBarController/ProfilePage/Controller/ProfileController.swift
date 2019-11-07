//
//  ProfileController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
    
class ProfileController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileData : [Profile]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        DummyDataProfile().getProfileData { (profileData) in
            self.profileData = profileData
        }
        
    }
    
    private func setupUI(){
        tableView.tableFooterView = UIView()
        
        let doneButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func doneAction(){
        dismiss(animated: true, completion: nil)
    }
    
}

