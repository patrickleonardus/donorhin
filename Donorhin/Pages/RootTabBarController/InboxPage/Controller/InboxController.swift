//
//  InboxController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class InboxController: UIViewController {
  
  var profileImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

      
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    profileImageNavBar(show: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    profileImageNavBar(show: false)
  }
  
  private func profileImageNavBar(show: Bool){
    
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
  
  //MARK: -Action Function
  @objc private func profileButton(){
    let storyboard = UIStoryboard(name: "Profile", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "profileStoryboard") as! ProfileController
    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
    self.present(navBarOnModal, animated: true, completion: nil)
  }

}
