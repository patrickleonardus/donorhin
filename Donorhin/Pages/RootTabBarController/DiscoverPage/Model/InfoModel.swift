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
            [InfoModel(image: "user_profile", title: "Cara Penggunaan Aplikasi", description: "Informasi cara penggunaan Donorhin"),
            InfoModel(image: "user_profile", title: "Syarat Pendonor", description: "Informasi seputar syarat Mendonor"),
            InfoModel(image: "user_profile", title: "Komunitas Rhesus Negatif", description: "Informasi terkait Komunitas Rhesus Negatif "),
            InfoModel(image: "user_profile", title: "Info Umum", description: "Informasi mengenai Unit Transfusi Darah (UTD)"),
            InfoModel(image: "user_profile", title: "Koordinator", description: "Informasi Mengenai Koordinator")]
        )
    }
}
