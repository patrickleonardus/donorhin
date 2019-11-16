//
//  Steps.swift
//  Donorhin
//
//  Created by Idris on 16/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
struct Steps {
  static func checkStep(_ step: Int) -> String {
    switch step {
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
      return "Pendonor ditemukan"
    }
  }
}
