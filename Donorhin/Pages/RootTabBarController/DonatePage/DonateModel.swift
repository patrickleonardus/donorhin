//
//  DonateModel.swift
//  Donorhin
//
//  Created by Idris on 08/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
import CloudKit

enum History {
  case active
  case history
}

struct TrackerModel {
  let idTracker: CKRecord
  let donorDate: String
  let idPendonor: CKRecord
  let idRequest: CKRecord
  let idUTDPendonor: CKRecord
  let currentStep: Int
}

struct ListRequest {
  let requests: [TrackerModel]
  init(_ requests: [TrackerModel]) {
    self.requests = requests
  }
}

