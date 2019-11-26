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
    var profileGender : Int?
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
        let birthdate : Date = ud.object(forKey: "birth_date") as? Date,
        let bloodType : String = ud.string(forKey: "blood_type")else { fatalError() }
        
        
        guard let lastDonor : Date = ud.object(forKey: "last_donor") as? Date else{return nil}
        
        let gender : Int = ud.integer(forKey: "gender")
        profileData = Profile(profileName: name, profileEmail: email, profileGender: gender, profileBirthday: birthdate, profileBloodType: bloodType, profileLastDonor: lastDonor)
        return profileData
    }
}

