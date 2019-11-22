//
//  Helper.swift
//  Donorhin
//
//  Created by Idris on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
import CloudKit
struct Helper {
  static let database = CKContainer.default().publicCloudDatabase
  typealias results = ([CKRecord]?) -> Void
  typealias result = (CKRecord?) -> Void
  typealias isSuccessSave = (Bool) -> Void
  static func getAllData(_ ckQuery: CKQuery, completion: @escaping results) {
    self.database.perform(ckQuery, inZoneWith: .default) { (results, error) in
      if let results = results {
        completion(results)
      }
      else {
        completion(nil)
      }
    }
  }
  
  static func getDataByID(_ ckRecord: CKRecord, completion: @escaping result) {
    self.database.fetch(withRecordID: ckRecord.recordID) { (result, error) in
      if let result = result {
        completion(result)
      }
      else {
        completion(nil)
      }
    }
  }
  
  static func saveData(_ ckRecord: CKRecord, completion: @escaping isSuccessSave) {
    self.database.save(ckRecord) { (res, err) in
        if res != nil {
        completion(true)
      }
      else {
        completion(false)
      }
    }
         
  }
  
  static func updateToDatabase(keyValuePair package: [String:Any?], recordID : CKRecord.ID){
    /**
     Ngupdate data ke cloud kit. Data di kirim dalam bentuk key:value pair. Contoh:
     ["current_step" : 3,
     "nama" : "Vebby",
     "birth_date" : Date()]
     
     Created by Vebby
     */
    
    Helper.database.fetch(withRecordID: recordID) { (record, error) in
      if let record = record, error == nil {
        
        //updating your record:
        for key in package.keys {
          if let value = package[key] {
            record.setValue(value, forKey: key)
          } else {
            record.setValue(nil, forKey: key)
          }
        }
        
        Helper.database.save(record) { (_, error) in
          if error != nil {
            print (error!.localizedDescription)
          }
        }
      }
      else {
        print ("failed to update value with record id \(recordID)")
      }
    }
    
  }
}
