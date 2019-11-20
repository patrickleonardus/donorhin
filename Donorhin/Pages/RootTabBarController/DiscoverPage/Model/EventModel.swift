//
//  EventModel.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct EventModel {
    let image : String?
    let title : String?
    let description : String?
    let address : String?
    let date : String?
    let nameEvent : String?
    let phoneEvent : String?
}

struct DummyDataForEvent {
    
    func getEventData(completionHandler: @escaping (([EventModel]) -> ())){
        completionHandler(
            [EventModel(image: "user_profile", title: "Ngumpul Bareng RNI Jakarta", description: "Kopdar antar anggota RNI se-jawa barat", address: "Grand Indonesia, Jakarta Pusat", date: "Hari Ini, 15.30 WIB", nameEvent: "Lici Murniati", phoneEvent: "08112102394"),
             EventModel(image: "user_profile", title: "Donor Darah", description: "Ayo selamatkan banyak nyawa dengan mendonor, satu darah sangat berarti bagi jutaan nyawa\nAyo selamatkan banyak nyawa dengan mendonor, satu darah sangat berarti bagi jutaan nyawa", address: "PMI Tangerang Selatan", date: "11-09-2019, 15.00", nameEvent: "Dede Pardede", phoneEvent: "081218302934")]
        )
    }
    
}
