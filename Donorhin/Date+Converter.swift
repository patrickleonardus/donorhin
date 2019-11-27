//
//  Date+Converter.swift
//  Donorhin
//
//  Created by Idris on 27/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
extension Date {
  func dateToString() -> String {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd-MM-yyyy"
    let newDate = dateFormatterPrint.string(from: self)
    return newDate
  }
}
