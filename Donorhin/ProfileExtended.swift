//
//  File.swift
//  Donorhin
//
//  Created by Idris on 08/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  //MARK: - setup profile image
  func setProfileImageNavBar(_ profileImage: UIImageView){
      var profileImage = profileImage
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
      
  }
  
  @objc private func profileButton(){
      let storyboard = UIStoryboard(name: "Profile", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "profileStoryboard") as! ProfileController
      let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
      self.present(navBarOnModal, animated: true, completion: nil)
  }
  
}


