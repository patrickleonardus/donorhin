//
//  TrackerDonor.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation

enum Status {
     case done
     case onGoing
     case toDo
}

struct StepItems {
    var description: String?
    var buttonStr : String?
    var status : Status?
}

enum DonorStatus {
    case searching
    case found
    case verified
    case done
}

struct Pendonor {
    let id : String?
    let name : String?
    let address : String?
    let date : String?
    let donorStatus : DonorStatus?
}

struct PendonorDummyData {
    func getCurrentPendonor(completionHandler: @escaping (([Pendonor]) -> ())){
        completionHandler(
            [Pendonor(id: "190", name: "Vebby", address: "PMI Tangsel", date: "31 Nov 2019", donorStatus: .done)])
    }
}
