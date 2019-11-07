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
    
    var bloodRequestHistory: [BloodRequest]?
    var bloodRequestCurrent: [BloodRequest]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        setupUI()
        
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
    
    private func setupUI(){
        setProfileImageNavBar()
    }
    
    private func callNumber(phoneNumber: String){
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func setProfileImageNavBar(){
        
        let profileImage = UIImageView(image: UIImage(named: "user_profile_default"))
        navigationController?.navigationBar.addSubview(profileImage)
        
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = ProfileImageSize.imageSize/2
        profileImage.clipsToBounds = true
        
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -ProfileImageSize.marginRight).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -ProfileImageSize.marginBottom).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: ProfileImageSize.imageSize).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: ProfileImageSize.imageSize).isActive = true
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileButton))
        profileImage.addGestureRecognizer(profileTap)
        
    }
    
    
    //MARK: Action
    
    @objc func callButton(){
        callNumber(phoneNumber: "081317019898")
    }
    
    @objc private func profileButton(){
        print("profileimagetapped!")
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


