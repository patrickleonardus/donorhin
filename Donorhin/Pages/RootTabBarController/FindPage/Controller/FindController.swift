//
//  FindController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FindController: UIViewController {
    
    
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findBloodSegmentedControl: UISegmentedControl!
    
    let cellId = "cellId"
    
    var profileImage = UIImageView()
    
    var bloodRequestHistory: [BloodRequest]?
    var bloodRequestCurrent: [BloodRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
      self.setProfileImageNavBar(self.profileImage)
        DummyData().getCurrentBloodRequest { (bloodRequest) in
            self.bloodRequestCurrent = bloodRequest
        }
        
        DummyData().getHistoryBloodRequest { (bloodRequests) in
            self.bloodRequestHistory = bloodRequests
        }
        
    }
    
    private func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FindBloodCustomCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    private func callNumber(phoneNumber: String){
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    //MARK: Action
    
    @objc func callButton(){
        callNumber(phoneNumber: "081317019898")
    }
    
    //MARK: Action Outlet

    @IBAction func findBloodSegmentedControlDidChange() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func findBloodAction(_ sender: Any) {
        viewNoData.isHidden = true
    }
    
}
