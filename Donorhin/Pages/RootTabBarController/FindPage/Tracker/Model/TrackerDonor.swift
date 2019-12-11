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


