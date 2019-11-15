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
  var status: History
  let date: String
}

struct DummyDataDonate {
  static let list = [Request(user: "Idris", step: 4,status: .active, date: "20-12-2019"),Request(user: "Somad", step: 3,status: .history, date: "20-12-2019")]
  static func getData(_ status: History,completion: @escaping ([Request]?) -> Void) {
    var temp = [Request]()
    temp = self.list.filter({ (key) -> Bool in
      key.status == status
    })
    if temp.count > 0 {
      completion(temp)
    }
    else {
      completion(nil)
    }
  }
}

