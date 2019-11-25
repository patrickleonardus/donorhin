//
//  Date + Time Removal.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 25/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//
import Foundation

extension String {
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        if let date = dateFormatter.date(from: self) {
            print(date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
