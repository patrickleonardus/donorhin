//
//  DiscoverController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverController: UIViewController, MoveToAddEvent, MoveToEventDetail, NavigationBarTitleDelegate, MoveToLoginFromDiscover, DiscoverAlert{
  
    @IBOutlet weak var tableViewDiscover: UITableView!
    
    var sectionHeaderTitleArray = ["Acara","Info"]
    var profileImage = UIImageView()
    var timer = Timer()
    var navigationBarTitle : String?
    
    //initialize var for collection view
    var imageEvent: UIImage?
    var titleEvent: String?
    var descEvent: String?
    var addressEvent: String?
    var dateEvent: Date?
    var nameEvent: String?
    var phoneEvent: String?
    var postedBy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      tabBarController?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(reloadCellCV), userInfo: nil, repeats: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageNavBar(show: true)
        setupNavBarToLarge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImageNavBar(show: false)
    }
    
    @objc func reloadCollectionViewData(){
        
        if let cell = tableViewDiscover.dequeueReusableCell(withIdentifier: "eventCell") as? EventTableViewCell{
            cell.loadData()
        }
    }
    
    @objc func reloadCellCV() {
        for cell in tableViewDiscover.visibleCells {
            if let cell = cell as? EventTableViewCell {
                DispatchQueue.main.async {
                    cell.loadData()
                    cell.collectionViewDiscover.reloadData()
                }
            }
        }
    }
    
    
    //MARK:- Setup UI
    
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
    
    private func setupNavBarToLarge(){
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
  
    //MARK:- Action Func
    
    @objc private func profileButton(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileStoryboard") as! ProfileController
      vc.discoverDelegate = self
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        self.present(navBarOnModal, animated: true, completion: nil)
    }
    
    func moveToAddEventClass() {
        self.performSegue(withIdentifier: "MoveToAdd", sender: self)
    }
    
    func moveToAddEventDetailClass(image: UIImage, title: String, desc: String, address: String, date: Date, name : String, phone : String, postedBy : String) {
        
        imageEvent = image
        titleEvent = title
        descEvent = desc
        addressEvent = address
        dateEvent = date
        nameEvent = name
        phoneEvent = phone
        self.postedBy = postedBy
        
        self.performSegue(withIdentifier: "MoveToDetailEvent", sender: self)
    }
  
  func showAlert() {
    
    let alert = UIAlertController(title: "Anda belum login", message: "Untuk mengakses fitur ini, anda perlu untuk melakukan login terlebih dahulu, apakah anda ingin Login?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Nanti Saja", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Login Sekarang", style: .default, handler: { (action) in
      self.performSegue(withIdentifier: "moveToLoginFormDiscover", sender: self)
    }))
  
    self.present(alert,animated: true)
  }
  
  func performLogin() {
    performSegue(withIdentifier: "moveToLoginFormDiscover", sender: self)
  }
  
  func setTabBar(show: Bool){
    if show {
      UIView.animate(withDuration: 0.2) {
        self.tabBarController?.tabBar.alpha = 1
      }
    }
    else {
      UIView.animate(withDuration: 0.2) {
        self.tabBarController?.tabBar.alpha = 0
      }
    }
  }
    
    func getNavigationTitle(cell: InfoTableViewCell, title: String) {
        self.navigationBarTitle = title
        self.performSegue(withIdentifier: "MoveToInformation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MoveToInformation" {
            let destination = segue.destination as! InformationController
            destination.navigationBarTitle = self.navigationBarTitle
            destination.sectionTotal = 2
        }
        else if segue.identifier == "MoveToDetailEvent" {
            let destination = segue.destination as! DetailEventController
            destination.imageEvent = imageEvent
            destination.titleEvent = titleEvent
            destination.descEvent = descEvent
            destination.addressEvent = addressEvent
            destination.dateEvent = dateEvent
            destination.nameEvent = nameEvent
            destination.phoneEvent = phoneEvent
            destination.postedBy = postedBy
        }
        
        else if segue.identifier == "moveToLoginFormDiscover" {
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? LoginController
                childViewController?.rootViewController = self
            }
        }
    }
  
  @IBAction func unwindFromInformationToDonor(storyboard : UIStoryboardSegue){
      setTabBar(show: true)
  }

}

protocol MoveToAddEvent {
    func moveToAddEventClass()
}

protocol MoveToEventDetail {
  func moveToAddEventDetailClass(image : UIImage, title: String, desc: String, address: String, date : Date, name : String, phone : String, postedBy : String)
}

protocol DiscoverAlert {
  func showAlert()
}
