//
//  Profile.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct Profile {
    let profileName : String?
    let profileEmail : String?
    let profileGender : String?
    let profileBirthday : Date
    let profileBloodType : String?
    let profileLastDonor : Date
    
    init() {
        let ud = UserDefaults.standard
        self.profileName = ud.string(forKey: "name") ?? ""
        self.profileEmail = ud.string(forKey: "email") ?? ""
        self.profileGender = ud.string(forKey: "gender") ?? ""
        self.profileBirthday = ud.object(forKey: "birthday") as! Date
        self.profileBloodType = ud.string(forKey: "bloodType") ?? ""
        self.profileLastDonor = ud.object(forKey: "lastDonor") as! Date
    }
}

//struct DummyDataProfile {
//
//       func getProfileData(completionHandler: @escaping (([Profile]) -> ())){
//         completionHandler(
//            [Profile(profileImage: "user_profile", profileName: "Nanda", profileEmail: "nanda@gmail.com", profileGender: "Perempuan", profileBirthday: "21 Feb 2000", profileBloodType: "O-", profileLastDonor: "01 Jan 2019")]
//         )
//     }
//
//}
