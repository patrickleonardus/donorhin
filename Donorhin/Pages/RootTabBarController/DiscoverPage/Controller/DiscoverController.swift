//
//  DiscoverController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DiscoverController: UIViewController, MoveToAddEvent, navigationBarTitleDelegate{

    @IBOutlet weak var tableViewDiscover: UITableView!
    
    var sectionHeaderTitleArray = ["Acara","Info"]
    var profileImage = UIImageView()
    
    var navigationBarTitle : String?
    
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
        
    }

}

protocol MoveToAddEvent {
    func moveToAddEventClass()
}
