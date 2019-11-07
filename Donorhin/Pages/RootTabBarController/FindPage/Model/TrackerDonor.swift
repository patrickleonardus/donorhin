//
//  TrackerDonor.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation

enum Status {
     case done
     case onGoing
     case toDo
}

struct StepItems {
    var description: String?
    var buttonStr : String?
    var status : Status?
}

