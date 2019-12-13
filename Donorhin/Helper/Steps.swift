//
//  Steps.swift
//  Donorhin
//
//  Created by Idris on 16/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation

enum StepsEnum {
  static let findingDonor_0 = 0
  static let donorFound_1 = 1
  static let willDonor_2 = 2
  static let willVerif_3 = 3
  static let donoring_4 = 4
  static let done_5 = 5
  static let received_6 = 6
}

struct Steps {
  static func checkStep(_ step: Int) -> String {
    switch step {
    case 0:
        return "Sedang mencari pendonor"
    case 1:
      return "Pendonor ditemukan"
    case 2:
      return "Pendonor akan mendonor di PMI"
    case 3:
      return "Pendonor sedang memverifikasi"
    case 4:
      return "Pendonor sedang mendonor"
    case 5:
      return "Pendonor selesai mendonor"
    default:
      return "Pendonor selesai mendonor"
    }
  }
}
