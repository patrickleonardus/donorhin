//
//  InfoModel.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct InfoModel {
    let image : String?
    let title : String?
    let description : String?
}

struct DummyDataForInfo {
    
    func getInfoData(completionHandler: @escaping (([InfoModel]) -> ())){
        completionHandler(
            [InfoModel(image: "user_profile", title: "Cara Penggunaan Rhelpus", description: "Informasi cara penggunaan Rhelpus"),
            InfoModel(image: "user_profile", title: "Syarat Pendonor", description: "Informasi Seputar syarat Mendonor"),
            InfoModel(image: "user_profile", title: "Rhesus Negatif", description: "Informasi seputar Rhesus Negatif "),
            InfoModel(image: "user_profile", title: "UTD", description: "Informasi seputar UTD "),
            InfoModel(image: "user_profile", title: "Bantuan", description: "Data Coming Soon")]
        )
    }
}
