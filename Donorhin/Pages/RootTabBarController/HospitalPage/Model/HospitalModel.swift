//
//  HospitalModel.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 20/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct HospitalModel {
    let id: String?
    let name: String?
    let alamat: String?
}

struct HospitalList {
    
    func getHospitalList(completionHandler: @escaping (([HospitalModel]) -> ())){
        completionHandler(
            [HospitalModel(id: "1", name: "PMI TANGSEL", alamat: "PMI TANGSEL"),
            HospitalModel(id: "2", name: "PMI JAKBAR", alamat: "PMI JAKBAR"),
            HospitalModel(id: "3", name: "PMI JAKSEL", alamat: "PMI JAKSEL"),
            HospitalModel(id: "4", name: "PMI JAKUT", alamat: "PMI JAKUT"),
            HospitalModel(id: "5", name: "PMI JAKTIM", alamat: "PMI JAKTIM")]
        )
    }
    
}
