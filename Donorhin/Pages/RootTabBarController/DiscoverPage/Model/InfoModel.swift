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
            [InfoModel(image: "user_profile", title: "Cara Penggunaan Aplikasi", description: "Informasi cara penggunaan Rhelpus"),
            InfoModel(image: "user_profile", title: "Syarat Pendonor", description: "Informasi seputar syarat Mendonor"),
            InfoModel(image: "user_profile", title: "Rhesus Negatif", description: "Informasi terkait Komunitas Rhesus Negatif "),
            InfoModel(image: "user_profile", title: "Unit Transfusi Darah (UTD)", description: "Informasi mengenai Unit Transfusi Darah"),
            InfoModel(image: "user_profile", title: "Bantuan", description: "Data Coming Soon")]
        )
    }
}
