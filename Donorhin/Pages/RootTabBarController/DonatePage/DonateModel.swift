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

struct Request {
  let idTracker: CKRecord
  let donorDate: String
  let idPendonor: CKRecord
  let idRequest: CKRecord
  let idUTDPendonor: CKRecord
  let currentStep: Int
}

struct ListRequest {
  let requests: [Request]
  init(_ requests: [Request]) {
    self.requests = requests
  }
}

