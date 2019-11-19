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


struct ListRequest {
  let requests: [TrackerModel]
  init(_ requests: [TrackerModel]) {
    self.requests = requests
  }
}

