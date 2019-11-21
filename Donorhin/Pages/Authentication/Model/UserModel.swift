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

enum AuthenticationState {
    case loggedin, loggedout
}

class DataFetcher {
 //   var user : UserData? = nil
    
    func getUserDataByEmail(email:String, password:String, completionHandler: @escaping ((UserModel?) -> Void)){
        print(email)
        print(password)
        var data : CKRecord? = nil
        
        let query = CKQuery(recordType: "Account", predicate: NSPredicate(format: "email = %@ AND password = %@", argumentArray: [email,password]))
        
        Helper.getAllData(query) { (results) in
            print("result: \(results)")
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
}

