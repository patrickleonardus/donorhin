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
    
    var profileImage : UIImageView?
    
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
        setProfileImageNavBar()
        setupNavBarToLarge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeProfileImageNavBar()
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
    
    private func setProfileImageNavBar(){
        
        profileImage = UIImageView(image: UIImage(named: "user_profile_default"))
        profileImage?.alpha = 0
        navigationController?.navigationBar.addSubview(profileImage!)
        
        profileImage!.isUserInteractionEnabled = true
        profileImage!.layer.cornerRadius = ProfileImageSize.imageSize/2
        profileImage!.clipsToBounds = true
        
        
        profileImage!.translatesAutoresizingMaskIntoConstraints = false
        profileImage!.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -ProfileImageSize.marginRight).isActive = true
        profileImage!.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -ProfileImageSize.marginBottom).isActive = true
        profileImage!.heightAnchor.constraint(equalToConstant: ProfileImageSize.imageSize).isActive = true
        profileImage!.widthAnchor.constraint(equalToConstant: ProfileImageSize.imageSize).isActive = true
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileButton))
        profileImage!.addGestureRecognizer(profileTap)
        
        UIView.animate(withDuration: 1.0) {
            self.profileImage?.alpha = 1
        }
        
    }
    
    private func removeProfileImageNavBar(){
        
        UIView.animate(withDuration: 0.15) {
            self.profileImage?.alpha = 0
        }
        
    }
    
    private func setupTabBarImage(){
        self.tabBarController?.tabBar.items![0].image = UIImage(named: "tab_bar_find")
        self.tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "tab_bar_find")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TrackerController
        destination.navigationBarTitle =  navBarTitle
    }
    
    //MARK: Action
    
    @objc func callButton(){
        callNumber(phoneNumber: "081317019898")
    }
    
    @objc private func profileButton(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileStoryboard") as! ProfileController
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        self.present(navBarOnModal, animated: true, completion: nil)
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
