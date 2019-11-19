//
//  String + Converter.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 19/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
extension String {
   func convertToBloodType() -> BloodType? {
      var bt: BloodType? = nil
      if self == "A-" {
         bt = .a
      } else if self == "B-" {
         bt = .b
      } else if self == "O-" {
         bt = .o
      } else if self == "AB-" {
         bt = .ab
      }
      return bt
   }
}
