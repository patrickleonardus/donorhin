//
//  Helper + DatabaseModel.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 18/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

struct TrackerModel {
   let idTracker: CKRecord.ID
   let idRequest: CKRecord.Reference
   var currentStep: Int
  let donorDate: Date?
  let idUTDPendonor: CKRecord.Reference?
  let idPendonor: CKRecord.Reference?
   
}

//struct EmptyTrackerModel {
//    let idTracker: CKRecord.ID
//    let idRequest: CKRecord.Reference
//    var currentStep: Int
//}

struct UserModel  {
   let idUser: CKRecord.ID
   let name: String
   let location: CLLocation?
   let bloodType: BloodType
   let statusDonor: Bool
   let email: String
   let password : String
   let birthdate: Date
   let lastDonor: Date?
   let gender: Gender
   let isVerified: Bool
}

struct UTDModel {
   let idUTD: CKRecord.ID
   let name: String
   let address: String
   let location: CLLocation
   let phoneNumbers: [String]?
   let province: String
}

struct EventGlobalModel {
   let idEvent: CKRecord.ID
   let title: String
   let description: String
   let image: UIImage?
   let address :  String
   let startTime: Date
   let endTime: Date
   let cpPhone: String
   let cpName: String
   let idUser: CKRecord.Reference
}

struct RequestModel {
   let idRequest: CKRecord.ID
   let patientName: String
   let bloodTypePatient: BloodType
   let amount: Int
   let dateNeed: Date
   let isEmergency: Bool
   let idUTDPatient: CKRecord.ID
    let idUser: CKRecord.ID
}
