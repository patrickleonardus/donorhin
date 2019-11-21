//
//  HospitalModel.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

struct HospitalModel {
    let id: CKRecord.ID?
    let name: String?
    let alamat: String?
}

struct HospitalList {
    
    func getHospitalList(completionHandler: @escaping (([HospitalModel]) -> ())){
        DispatchQueue.main.async {
            var hospitalModel : [HospitalModel] = []
            
            let query = CKQuery(recordType: "UTD", predicate: NSPredicate(value: true))
            Helper.getAllData(query) { (results) in
                if let results = results {
                    for result in results {
                        let model = result.convertUTDToUTDModel() //kalo nil == error
                        if let model = model {
                            hospitalModel.append(HospitalModel(id: model.idUTD,
                                                               name: model.name,
                                                               alamat: model.address))
                        } else {
                            print ("nil value of result")
                        }
                    }
                }
                completionHandler(hospitalModel)
            }
            
           
        }
    }
    
    
}
