//
//  UserModel.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 18/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit

//struct UserData {
//    var email:String?
//    var password:String?
//    var name:String?
//    var location: NSData?
//    var bloodType: String?
//    var birthDate: Date?
//    var gender: Int?
//    var donorStatus: Int?
//    var lastDonor: Date?
//    var isVerified: Int?
//    var imageData: NSData?
//}

class DataFetcher {
 //   var user : UserData? = nil
    
    func getUserDataByEmail(email:String, password:String, completionHandler: @escaping ((UserModel?) -> Void)){
        print(email)
        print(password)
        var data : CKRecord? = nil
        
        let query = CKQuery(recordType: "Account", predicate: NSPredicate(format: "email = %@ AND password = %@", argumentArray: [email,password]))
        
        Helper.getAllData(query) { (results) in
            //print("result: \(results)")
            DispatchQueue.main.async {
                let userModel:UserModel?
                if results?.count != 0{
                    for record in results!{
                        UserDefaults.standard.set(record.recordID.recordName, forKey: "currentUser") //save record name to user default
                        data = record
                    }
                    userModel = data?.convertAccountToUserModel()
                    completionHandler(userModel)
                }
                else{
                    completionHandler(nil)
                }
            }
        }
    }
    
//    func appendUser(userData:CKRecord?) -> UserData? {
//        guard
//        let email : String = userData?.value(forKey: "email") as? String,
//        let password : String = userData?.value(forKey: "password") as? String,
//        let name : String = userData?.value(forKey: "name") as? String,
//        let gender : Int = userData?.value(forKey: "gender") as? Int,
//        let birthdate : Date = userData?.value(forKey: "birth_date") as? Date,
//        let bloodType : String = userData?.value(forKey: "blood_type") as? String,
//        let lastDonor : Date = userData?.value(forKey: "last_donor") as? Date,
//        let location : CLLocation = userData?.value(forKey: "location") as? CLLocation,
//        let isVerified : Int = userData?.value(forKey: "isVerified") as? Int,
//        let donorStatus : Int = userData?.value(forKey: "donor_status") as? Int,
//        let image : CKAsset = userData?.value(forKey: "image") as? CKAsset,
//        let imageData : NSData = NSData(contentsOf: image.fileURL!)
//        else {fatalError()}
//
//        let locationData : NSData = NSKeyedArchiver.archivedData(withRootObject: location) as NSData
//        user = UserData(email: email, password: password, name: name, location: locationData, bloodType: bloodType, birthDate: birthdate, gender: gender, donorStatus: donorStatus, lastDonor: lastDonor, isVerified: isVerified, imageData: imageData)
//        return user
//    }
}
