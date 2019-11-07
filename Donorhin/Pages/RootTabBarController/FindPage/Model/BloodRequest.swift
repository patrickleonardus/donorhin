//
//  BloodRequest.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct BloodRequest {
    let id : String?
    let name : String?
    let address : String?
    let date : String?
    let status : String?
}

struct ProfileImageSize {
    static let imageSize : CGFloat = 40
    static let marginRight : CGFloat = 20
    static let marginBottom : CGFloat = 10
}

struct DummyData {
    
    func getCurrentBloodRequest(completionHandler: @escaping (([BloodRequest]) -> ())){
        completionHandler(
            [BloodRequest(id: "190", name: "Patrick", address: "PMI BOGOR", date: "30 Nov 2019", status: "Pendonor Ditemukan")]
        )
    }
    
    func getHistoryBloodRequest(completionHandler: @escaping (([BloodRequest]) -> ())) {
        completionHandler(
            [BloodRequest(id: "123", name: "Idris", address: "PMI TANGSEL", date: "06 Nov 2019", status: "Selesai"),
             BloodRequest(id: "212", name: "Vebby", address: "PMI JAKSEL", date: "01 Nov 2019", status: "Selesai"),
             BloodRequest(id: "222", name: "Nanda", address: "PMI BALI", date: "31 Okt 2019", status: "Selesai"),
             BloodRequest(id: "321", name: "Kosasi", address: "PMI Medan", date: "20 Okt 2019", status: "Selesai"),
             BloodRequest(id: "221", name: "Yuva", address: "PMI Bekasi", date: "10 Jul 2019", status: "Selesai"),
             BloodRequest(id: "110", name: "Annisa", address: "PMI TANGSEL", date: "5 Jan 2019", status: "Selesai")
            ]
        )
    }
}
