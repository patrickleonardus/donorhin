//
//  PMIModel.swift
//  Donorhin
//
//  Created by Idris on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
struct DonatePMIModel {
  let id: String
  let name: String
  let alamat: String
}

struct DummyPMI {
  static var list: [DonatePMIModel] = [DonatePMIModel(id: "1", name: "PMI Tangerang Selatan", alamat: "Tangerang Selatan")]
}
