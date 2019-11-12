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
    let address : String?
    let date : String?
}

struct DummyDataForEvent {
    
    func getEventData(completionHandler: @escaping (([EventModel]) -> ())){
        completionHandler(
            [EventModel(image: "user_profile", title: "Ngumpul Bareng RNI Jakarta", address: "Grand Indonesia, Jakarta Pusat", date: "Hari Ini, 15.30 WIB"),
            EventModel(image: "user_profile", title: "Donor Darah", address: "PMI Tangerang Selatan", date: "11-09-2019, 15.00")]
        )
    }
    
}
