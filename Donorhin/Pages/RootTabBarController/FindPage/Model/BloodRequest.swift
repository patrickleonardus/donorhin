//
//  BloodRequest.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

struct BloodRequest {
    let requestId : CKRecord.ID?
    var hospitalId : CKRecord.ID?
    let name : String?
    var address : String?
    var phoneNumber : String?
    let date : Date?
    var status : Int?
}

struct ProfileImageSize {
    static let imageSize : CGFloat = 40
    static let marginRight : CGFloat = 20
    static let marginBottom : CGFloat = 10
}

struct DummyData {
    
    //INI UDH GA DIPAKE LAGI YA GUYS, GW NARIK DATANYA LEWAT FIND CONTROLLERNYA LANGSUNG
    
//    func getPatientData(completion: @escaping (([BloodRequest]) -> ())){
//        var bloodRequest : [BloodRequest] = []
//        var nameTemp : String?
//        var dateTemp: Date?
//        var hospitalNameTemp: String?
//        var hospitalNumberTemp: String?
//        var requestId : CKRecord.ID?
//        var hospitalId: CKRecord.ID?
//        let userId =  UserDefaults.standard.string(forKey: "currentUser")
//        var currStep: Int?
//
//        let dispatchQueue = DispatchQueue.global(qos: .background)
//        let semaphore = DispatchSemaphore(value: 0)
//
//        if userId != nil {
//
//            dispatchQueue.async {
//
//                let userIdReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: userId!), action: .none)
//                let requestPredicate = NSPredicate(format: "userId = %@", argumentArray: [userIdReference])
//                let requestQuery = CKQuery(recordType: "Request", predicate: requestPredicate)
//
//                Helper.getAllData(requestQuery) { (requestResults) in
//                    guard let requestResults = requestResults else {fatalError("Query in Request Error")}
//                    for requestResult in requestResults {
//                        let requestModels = requestResult.convertRequestToRequestModel()
//                        guard let requestModel = requestModels else {fatalError("Error when convert request to model")}
//                        nameTemp = requestModel.patientName
//                        dateTemp = requestModel.dateNeed
//                        requestId = requestModel.idRequest
//                        hospitalId = requestModel.idUTDPatient
//
//                        bloodRequest.append(BloodRequest(requestId: requestId!, hospitalId: hospitalId, name: nameTemp!, address: nil, phoneNumber: nil, date: dateTemp, status: nil))
//                    }
//                    semaphore.signal()
//                }
//                semaphore.wait()
//
//                //------------
//                for request in 0...bloodRequest.count-1 {
//                    guard let hospitalId = bloodRequest[request].hospitalId else {fatalError("hospitalId not found")}
//                    let record = CKRecord(recordType: "UTD", recordID: hospitalId)
//                    Helper.getDataByID(record){ (utdResults) in
//                        guard let utdResults = utdResults else {fatalError("utdResults not found")}
//                        let utdModels = utdResults.convertUTDToUTDModel()
//                        guard let utdModel = utdModels else {fatalError("utdModel not found")}
//                        hospitalNameTemp = utdModel.name
//                        hospitalNumberTemp = utdModel.phoneNumbers![0]
//
//                        bloodRequest[request].address = hospitalNameTemp
//                        bloodRequest[request].phoneNumber = hospitalNumberTemp
//                    }
//                    semaphore.signal()
//                }
//
//                semaphore.wait()
//
//                //------------
//                for request in 0...bloodRequest.count-1 {
//                    guard let requestId = bloodRequest[request].requestId else {fatalError("requestId not found")}
//                    let trackerPredicate = NSPredicate(format: "id_request = %@", argumentArray: [requestId])
//                    let trackerQuery = CKQuery(recordType: "Tracker", predicate: trackerPredicate)
//                    Helper.getAllData(trackerQuery) {(trackerResults) in
//                        guard let trackerResults = trackerResults else {fatalError("trackerResult not found")}
//                        for trackerResult in trackerResults {
//                            let trackerModels = trackerResult.convertTrackerToTrackerModel()
//                            guard let trackerModel = trackerModels else {fatalError("trackerModel not found")}
//                            currStep = trackerModel.currentStep
//                            bloodRequest[request].status = currStep
//                            print(bloodRequest)
//                        }
//                    }
//                    semaphore.signal()
//                }
//                semaphore.wait()
//            }
//        }
//
//
//    }
}
