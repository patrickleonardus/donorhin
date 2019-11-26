//
//  TrackerDonor.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import CloudKit

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

//FIXME: DELETE
enum DonorStatus {
    case searching
    case found
    case verified
    case done
    case confirmed
}

//FIXME: DELETE SOON, Ganti sama SearchTrackerModel
struct Pendonor {
    var id : String?
    var name : String?
    var address : String?
    var date : String?
    var donorStatus : DonorStatus?
}

struct SearchTrackerInput {
  var idRequest : CKRecord.ID
  var idTracker : CKRecord.ID
  var patientUtdId : CKRecord.ID
  var step : Int
}

struct SearchTrackerModel{
  var datePendonor : Date? //tracker
  var pendonorUTDName : String? //tracker
  var pendonorUTDPhone : [String]? //tracker
}

struct PendonorDummyData {
    func getCurrentPendonor(completionHandler: @escaping (([Pendonor]) -> ())){
        completionHandler(
            [Pendonor(id: "190", name: "Vebby", address: "PMI Tangsel", date: "31 Nov 2019", donorStatus: .done)])
    }
}

