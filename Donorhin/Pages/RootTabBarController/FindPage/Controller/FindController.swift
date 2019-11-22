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
    
    var requestDelegate : ControlValidationViewDelegate?
    
    var navBarTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageNavBar(show: true)
        setupNavBarToLarge(large: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImageNavBar(show: false)
    }
    
    private func loadData(){
        
        self.showSpinner(onView: self.view)
        
        DummyData().getBloodRequest { (bloodRequest) in
            
            DispatchQueue.main.async {
                self.bloodRequestCurrent = bloodRequest
                self.bloodRequestHistory = bloodRequest
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
                self.removeSpinner()
                
                if self.bloodRequestCurrent != nil {
                    if self.bloodRequestCurrent!.count == 0 {
                        self.viewNoData.alpha = 1
                    }
                    else {
                        self.viewNoData.alpha = 0
                    }
                }
                else {
                    self.viewNoData.alpha = 1
                }
                
            }
            
        }
    }
    
    
    //MARK: - initialize variable
    private func initTableView(){
        tableView.register(UINib(nibName: "FindBloodCustomCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavBarToLarge(large: Bool){
        if large {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        else {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
        
    private func callNumber(phoneNumber: String){
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // ini untuk buat tanggal di tableview jadi ringkes
    func shrinkDate(_ date: Date) -> String{
        
        let dfPrint = DateFormatter()
        dfPrint.dateFormat = "dd MMMM yyyy"
        
        return dfPrint.string(from: date)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToForm" {
            
            guard let navigationController = segue.destination as? UINavigationController else {return}
            guard let formController = navigationController.viewControllers.first as? FormController else {return}
            
            formController.viewValidationDelegate = sender as? ControlValidationViewDelegate
            
        }
        else if segue.identifier == "moveToTracker" {
            
            let destination = segue.destination as! TrackerController
            destination.navigationBarTitle =  navBarTitle
            
        }
        
    }
    
    func profileImageNavBar(show: Bool){
        
        let navBarHeight = Double((navigationController?.navigationBar.frame.height)!)
        
        if show {
            if navBarHeight >= 90.0 {
                profileImage = UIImageView(image: UIImage(named: "user_profile_default"))
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
                
                UIView.animate(withDuration: 1.0) {
                    self.profileImage.alpha = 1.0
                }
            }
        }
        
        else {
            UIView.animate(withDuration: 0.1) {
                self.profileImage.alpha = 0.0
               
            }
        }
    }
    
    //MARK: Action
    
    @objc func callButton(sender: UIButton){
        let button = (sender as! CallNumberButton)
        callNumber(phoneNumber: button.phoneNumber!)
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
        performSegue(withIdentifier: "moveToForm", sender: self)
    }
    
}

protocol ControlValidationViewDelegate {
    func didRequestData()
}
