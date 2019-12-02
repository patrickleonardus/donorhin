//
//  BloodRequest.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

struct Donor {
    let requestId : CKRecord.ID?
    var trackerId : CKRecord.ID?
    var donorHospitalID : CKRecord.ID?
    var donorHospitalName : String?
    var phoneNumber : String?
    let donorDate : Date?
    var status : Int?
}

struct ProfileImageSize {
    static let imageSize : CGFloat = 40
    static let marginRight : CGFloat = 20
    static let marginBottom : CGFloat = 10
}
