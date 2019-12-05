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
    func getUserDataByEmail(email:String, password:String, completionHandler: @escaping ((UserModel?) -> Void)){
        print(email)
        print(password)
        var data : CKRecord? = nil
        
        let query = CKQuery(recordType: "Account", predicate: NSPredicate(format: "email = %@", email))
        
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
                    
                    if userModel?.password != password{
                        completionHandler(nil)
                    }
                    completionHandler(userModel)
                }
                else{
                    completionHandler(nil)
                }
            }
        }
    }
}

class PasswordCryptor {
    func encryptMessage(password: String) -> String {
        let passwordData = password.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: passwordData, withPassword: "hash")
        return cipherData.base64EncodedString()
    }

    func decryptMessage(encryptedPassword: String) throws -> String {
        let encryptedData = Data.init(base64Encoded: encryptedPassword) ?? nil
        if encryptedData == nil {
            return encryptedPassword
        }
        let decryptedData = try RNCryptor.decrypt(data: encryptedData!, withPassword: "hash")
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        return decryptedString
    }
}

