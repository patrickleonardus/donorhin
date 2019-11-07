//
//  Profile.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct Profile {
    let profileImage : String?
    let profileName : String?
    let profileEmail : String?
    let profileGender : String?
    let profileBirthday : String?
    let profileBloodType : String?
    let profileLastDonor : String?
}

struct DummyDataProfile {
    
       func getProfileData(completionHandler: @escaping (([Profile]) -> ())){
         completionHandler(
            [Profile(profileImage: "user_profile", profileName: "Nanda", profileEmail: "nanda@gmail.com", profileGender: "Perempuan", profileBirthday: "21 Feb 2000", profileBloodType: "O-", profileLastDonor: "01 Jan 2019")]
         )
     }
    
}
