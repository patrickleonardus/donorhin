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
      else if self == "A+" {
         bt = .aPositive
      }
      else if self == "B+" {
         bt = .bPositive
      }
      else if self == "O+" {
         bt = .oPositive
      }
      else if self == "AB+" {
         bt = .abPositive
      }
      else if self == "Belum Diketahui" {
       bt = .notIdentified
      }
      return bt
   }
}
