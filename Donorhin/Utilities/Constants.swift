//
//  Constants.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

enum BloodType: String {
    case o = "O-"
    case b = "B-"
    case a = "A-"
    case ab = "AB-"
}

enum Colors{
    static let red = UIColor(red: 179/255, green: 0/255, blue: 27/255, alpha: 1)
    static let gray_disabled = UIColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
    static let green = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)
    static let backgroundView = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    static let gray_line = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.4)
    static let gray = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
}

enum UDDevice{
   // get from user default
   static let heightScreen = UserDefaults.standard.integer(forKey:"userScreenHeight")
   static let widthScreen = UserDefaults.standard.integer(forKey:"userScreenWidth")
}

