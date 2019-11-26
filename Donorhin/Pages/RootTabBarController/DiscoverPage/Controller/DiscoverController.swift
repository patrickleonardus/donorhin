//
//  DiscoverController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverController: UIViewController, MoveToAddEvent, MoveToEventDetail, navigationBarTitleDelegate{

    @IBOutlet weak var tableViewDiscover: UITableView!
    
    var sectionHeaderTitleArray = ["Acara","Info"]
    var profileImage = UIImageView()
    
    var navigationBarTitle : String?
    
    //initialize var for collectio view
    var imageEvent: String?
    var titleEvent: String?
    var descEvent: String?
    var addressEvent: String?
    var dateEvent: String?
    var nameEvent: String?
    var phoneEvent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageNavBar(show: true)
        setupNavBarToLarge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImageNavBar(show: false)
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
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        self.present(navBarOnModal, animated: true, completion: nil)
    }
    
    func moveToAddEventClass() {
        self.performSegue(withIdentifier: "MoveToAdd", sender: self)
    }
    
    func moveToAddEventDetailClass(image: String, title: String, desc: String, address: String, date: String, name : String, phone : String) {
        
        imageEvent = image
        titleEvent = title
        descEvent = desc
        addressEvent = address
        dateEvent = date
        nameEvent = name
        phoneEvent = phone
        
        self.performSegue(withIdentifier: "MoveToDetailEvent", sender: self)
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
        }
    }

}

protocol MoveToAddEvent {
    func moveToAddEventClass()
}

protocol MoveToEventDetail {
    func moveToAddEventDetailClass(image : String, title: String, desc: String, address: String, date : String, name : String, phone : String)
}
