//
//  Profile.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct Profile {
    var profileName : String?
    var profileEmail : String?
    var profileGender : String?
    var profileBirthday : Date?
    var profileBloodType : String?
    var profileLastDonor : Date?
}

class ProfileDataFetcher {
    var profileData:Profile? = nil
    
    func getProfileFromUserDefaults(completionHandler: @escaping ((Profile?) -> Void)){
        let ud = UserDefaults.standard
        var profile : Profile? = nil
        if ud.string(forKey: "currentUser") != nil {
            profile = self.appendUser()
        }
        else {
            completionHandler(nil)
        }
        completionHandler(profile)
    }
    
    func appendUser() -> Profile? {
        let ud = UserDefaults.standard
        guard
        let email : String = ud.string(forKey: "email"),
        let name : String = ud.string(forKey: "name"),
        let gender : String = ud.string(forKey: "gender"),
        let birthdate : Date = ud.object(forKey: "birthday") as? Date,
        let bloodType : String = ud.string(forKey: "blood_type"),
        let lastDonor : Date = ud.object(forKey: "last_donor") as? Date else {fatalError()}
        profileData = Profile(profileName: name, profileEmail: email, profileGender: gender, profileBirthday: birthdate, profileBloodType: bloodType, profileLastDonor: lastDonor)
        return profileData
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
