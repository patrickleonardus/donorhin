//
//  ProfileController+UITableView.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension ProfileController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = 0
        
        if indexPath.section == 0 {
            height = 200
        }
        
        else if indexPath.section == 1 {
            height = 70
        }
        
        else if indexPath.section == 2 {
            height = 70
        }
        
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        if section == 0 {
            numberOfRows = 1
        }
        
        else if section == 1 {
            numberOfRows = 4
        }
        
        else if section  == 2 {
            numberOfRows = 1
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        
        var user = Profile()
        
//        guard let data = profileData?[0] else {fatalError()}
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? FirstCell
                                           
            cell?.nameProfile.text = user.profileName
            cell?.emailProfile.text = user.profileEmail
            cell?.imageProfile.image = UIImage(named: "user_profile")
            
            
            return cell!
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as? SecondCell
        
            if indexPath.row == 0 {
                cell?.imageCell.image = UIImage(named: "gender_profile")
                cell?.textCell.text = user.profileGender
            }
            
            else if indexPath.row == 1 {
                cell?.imageCell.image = UIImage(named: "birthday_profile")
                cell?.textCell.text = dateFormatter.string(from: user.profileBirthday)
            }
            
            else if indexPath.row == 2 {
                cell?.imageCell.image = UIImage(named: "bloodtype_profile")
                cell?.textCell.text = user.profileBloodType
            }
            
            else if indexPath.row == 3 {
                cell?.imageCell.image = UIImage(named: "lastdonor_profile")
                cell?.textCell.text = dateFormatter.string(from: user.profileLastDonor)
            }
            
            return cell!
        }
        
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell", for: indexPath) as? ThirdCell
            
            cell?.logoutOutlet.setTitle("Logout", for: .normal)
            cell?.logoutOutlet.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
            
            return cell!
        }
        
        return UITableViewCell()
    }
    
    
    
}
