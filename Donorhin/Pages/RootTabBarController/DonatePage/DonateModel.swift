//
//  DonateModel.swift
//  Donorhin
//
//  Created by Idris on 08/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation

enum History {
  case active
  case history
}

struct Request {
  let user: String
  let step: Int
  let status: History = .active
  let date: String
}

struct ListDonate {
  static let list = [Request(user: "Idris", step: 2, date: "20-12-2019")]
}

