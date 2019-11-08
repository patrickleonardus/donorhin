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
    
    var navBarTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        
        DummyData().getCurrentBloodRequest { (bloodRequest) in
            self.bloodRequestCurrent = bloodRequest
        }
        
        DummyData().getHistoryBloodRequest { (bloodRequests) in
            self.bloodRequestHistory = bloodRequests
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.setProfileImageNavBar(self.profileImage)
      setupNavBarToLarge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      self.removeProfileImageNavBar(self.profileImage)
    }
    
    
    //MARK: - initialize variable
    private func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FindBloodCustomCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavBarToLarge(){
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
        
    private func callNumber(phoneNumber: String){
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TrackerController
        destination.navigationBarTitle =  navBarTitle
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
