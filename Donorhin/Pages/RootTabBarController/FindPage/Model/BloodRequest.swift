//
//  BloodRequest.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation

struct BloodRequest {
    let name : String?
    let status : String?
}


struct DummyData {
    func getBloodRequest(completionHandler: (([BloodRequest]) -> ())) {
        completionHandler(
            [BloodRequest(name: "Idris", status: "Approved")]
        )
    }
}
