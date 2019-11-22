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
    let id : CKRecord.ID
    let name : String?
    let address : String?
    let phoneNumber : String?
    let date : Date?
    let status : Int?
}

struct ProfileImageSize {
    static let imageSize : CGFloat = 40
    static let marginRight : CGFloat = 20
    static let marginBottom : CGFloat = 10
}

struct DummyData {
    
    func getBloodRequest(completionHandler: @escaping (([BloodRequest]) -> ())){
        DispatchQueue.main.async {
            
            var bloodRequest : [BloodRequest] = []
            
            var nameTemp : String?
            var hospitalNameTemp: String?
            var hospitalNumberTemp: String?
            var dateTemp: Date?
            var status: Int?
            
            var requestId : CKRecord.ID?
            
            let userId =  UserDefaults.standard.string(forKey: "currentUser")
            
            if userId != nil {
                let uid = CKRecord.Reference(recordID: CKRecord.ID(recordName: userId!), action: .none)
                let reqPredicate = NSPredicate(format: "userId = %@", argumentArray: [uid])
                
                //Query ke table request buat ambil request
                let reqQuery = CKQuery(recordType: "Request", predicate: reqPredicate)
                Helper.getAllData(reqQuery) { (reqResults) in
                    if let reqResults = reqResults {
                        for reqResult in reqResults {
                            let reqModel = reqResult.convertRequestToRequestModel()
                            if let reqModel = reqModel {
                                nameTemp = reqModel.patientName
                                dateTemp = reqModel.dateNeed
                                requestId = reqModel.idRequest
                                
                                let hospitalId = reqModel.idUTDPatient
                                let record = CKRecord(recordType: "UTD", recordID: hospitalId)
                                
                                //query ke table utd buat ambil alamat sama no telp utd
                                Helper.getDataByID(record) { (utdResults) in
                                    if let utdResults = utdResults {
                                        let utdModel = utdResults.convertUTDToUTDModel()
                                        if let utdModel = utdModel {
                                            hospitalNameTemp = utdModel.name
                                            hospitalNumberTemp = utdModel.phoneNumbers![1]
                                            
                                            //query ke table tracker buat tau status request
                                            let rid = CKRecord.Reference(recordID: requestId!, action: .none)
                                            let trackerPredicate = NSPredicate(format: "id_request = %@", argumentArray: [rid])
                                            let trcQuery = CKQuery(recordType: "Tracker", predicate: trackerPredicate)
                                            Helper.getAllData(trcQuery){ (trcResults) in
                                                if let trcResults = trcResults {
                                                    for trcResult in trcResults {
                                                        let trcModel = trcResult.convertTrackerToTrackerModel()
                                                        if let trcModel = trcModel {
                                                            status = trcModel.currentStep
                                                        }
                                                    }
                                                    bloodRequest.append(BloodRequest(id: reqModel.idRequest, name: nameTemp, address: hospitalNameTemp, phoneNumber: hospitalNumberTemp, date: dateTemp, status: status))
                                                    print(bloodRequest)
                                                    completionHandler(bloodRequest)

                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
//    
//    func getCurrentBloodRequest(completionHandler: @escaping (([BloodRequest]) -> ())){
//        completionHandler(
//            [BloodRequest(id: "190", name: "Patrick", address: "PMI BOGOR", date: "30 Nov 2019", status: "Pendonor Ditemukan")]
//        )
//    }
//
//    func getHistoryBloodRequest(completionHandler: @escaping (([BloodRequest]) -> ())) {
//        completionHandler(
//            [BloodRequest(id: "123", name: "Idris", address: "PMI TANGSEL", date: "06 Nov 2019", status: "Selesai"),
//             BloodRequest(id: "212", name: "Vebby", address: "PMI JAKSEL", date: "01 Nov 2019", status: "Selesai"),
//             BloodRequest(id: "222", name: "Nanda", address: "PMI BALI", date: "31 Okt 2019", status: "Selesai"),
//             BloodRequest(id: "321", name: "Kosasi", address: "PMI Medan", date: "20 Okt 2019", status: "Selesai"),
//             BloodRequest(id: "221", name: "Yuva", address: "PMI Bekasi", date: "10 Jul 2019", status: "Selesai"),
//             BloodRequest(id: "110", name: "Annisa", address: "PMI TANGSEL", date: "5 Jan 2019", status: "Selesai")
//            ]
//        )
//    }
}
