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
  let idTracker: CKRecord
  let donorDate: String
  let idPendonor: CKRecord
  let idRequest: CKRecord
  let idUTDPendonor: CKRecord
  let currentStep: Int
   
}

struct UserModel  {
   let name: String
   let location: CLLocation?
   let bloodType: BloodType
   let statusDonor: Bool
   let email: String
   let password : String
   let birthdate: Date
   let lastDonor: Date
   let gender: Gender
   let isVerified: Bool
}

struct UTDModel {
   let name: String
   let address: String
   let location: CLLocation
   let phone: String?
}

struct Event {
   let title: String
   let description: String
   let image: UIImage?
   let address :  String
   let startTime: Date
   let endTime: Date
   let cpPhone: String
   let cpName: String
   let idUser: CKRecord
}

struct Request {
   let patientName: String
   let bloodTypePatient: BloodType
   let amount: Int
   let dateNeed: Date
   let isEmergency: Bool
   let imageOfLetter: UIImage
   let idUTDPatient: CKRecord
}
