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
            [InfoModel(image: "user_profile", title: "Cara Penggunaan Aplikasi", description: "Tutorial cara pengunaan Donorhin"),
            InfoModel(image: "user_profile", title: "Daftar Syarat Pendonor", description: "Persiapan sebelum mendonor"),
            InfoModel(image: "user_profile", title: "Kontak UTD PMI", description: "Mengetahui andil kontak UTD PMI "),
            InfoModel(image: "user_profile", title: "Info Umum", description: "Mengenal istilah BPPD dan Rhesus"),
            InfoModel(image: "user_profile", title: "Apa itu Koordinator?", description: "Istilah koordinator dalam Donorhin"),
          InfoModel(image: "user_profile", title: "Hubungi Donorhin", description: "Daftar kontak tim aplikasi")]
        )
    }
}
