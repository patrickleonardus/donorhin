//
//  CKRecord + Converter.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 18/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import CloudKit
import UIKit

extension CKAsset {
   func toUIImage() -> UIImage? {
      if let url = self.fileURL{
         if let data = NSData(contentsOf: url) {
            return UIImage(data: data as Data)
         }
      }
      return nil
   }
}

extension CKRecord {
   func convertTrackerToTrackerModel() -> TrackerModel? {
      guard let donordate = self.value(forKey: "donor_date") as? Date ?? nil
         else {
//            fatalError("failed casting data with record ID \(self.recordID)")
            return nil }
      guard let idpendonor = self.value(forKey: "id_pendonor") as? Reference ?? nil
         else {
//            fatalError("failed casting data with record ID \(self.recordID)")
            return nil }
      guard let idrequest = self.value(forKey: "id_request") as? Reference ?? nil
         else {
//            fatalError("failed casting data with record ID \(self.recordID)")
            return nil }
      guard let idUTDPendonor = self.value(forKey: "id_UTD_pendonor") as? Reference ?? nil
         else {
//            fatalError("failed casting data with record ID \(self.recordID)")
            return nil }
      guard let currentStep = self.value(forKey: "current_step") as? Int ?? nil
         else {
//            fatalError("failed casting data with record ID \(self.recordID)")
            return nil }
      
      let trackerModel = TrackerModel(idTracker: self.recordID,
                                      donorDate: donordate,
                                      idPendonor: idpendonor,
                                      idRequest: idrequest,
                                      idUTDPendonor: idUTDPendonor,
                                      currentStep: currentStep)
      return trackerModel
   }
   
   func convertRequestToRequestModel() -> RequestModel? {
      guard let patientName = self.value(forKey: "patient_name") as? String ?? nil
         else { return nil }
      guard let bloodTypePatient =
         (self.value(forKey: "patient_blood_type") as? String ?? nil)?.convertToBloodType()
         else { return nil }
      guard let amount = self.value(forKey: "amount") as? Int ?? nil
         else { return nil }
      guard let dateNeed = self.value(forKey: "date_need") as? Date ?? nil
         else { return nil }
      guard let isEmergency = self.value(forKey: "isEmergency") as? Int ?? nil
         else { return nil }
      guard let idUTDPatient = self.value(forKey: "UTD_patient") as? Reference ?? nil
         else { return nil }
      
      let requestModel = RequestModel(idRequest: self.recordID,
                                      patientName: patientName,
                                      bloodTypePatient: bloodTypePatient,
                                      amount: amount,
                                      dateNeed: dateNeed,
                                      isEmergency: (isEmergency==1),
                                       idUTDPatient: idUTDPatient)
      
      
      return requestModel
   }
   
   func convertEventToEventGlobalModel ()  -> EventGlobalModel?{
      
      guard let title = self.value(forKey: "title") as? String ?? nil else { return nil }
      guard let description = self.value(forKey: "description") as? String ?? nil else { return nil }
      guard let address = self.value(forKey: "address") as? String ?? nil else { return nil }
      guard let startTime = self.value(forKey: "start_time") as? Date ?? nil else { return nil }
      guard let endTime = self.value(forKey: "end_time") as? Date ?? nil else { return nil }
      guard let cpPhone = self.value(forKey: "contact_phone") as? String ?? nil else { return nil }
      guard let cpName = self.value(forKey: "contact_name") as? String ?? nil else { return nil }
      guard let idUser = self.value(forKey: "reference_account") as? Reference ?? nil else { return nil }
      let image : CKAsset? = self.object(forKey: "image") as? CKAsset
      
      let eventModel = EventGlobalModel(idEvent: self.recordID,
                                        title: title,
                                        description: description,
                                        image: image?.toUIImage(),
                                        address: address,
                                        startTime: startTime,
                                        endTime: endTime,
                                        cpPhone: cpPhone,
                                        cpName: cpName,
                                        idUser: idUser)
      return eventModel
      
   }
   
   func convertAccountToUserModel() -> UserModel? {
      guard let name = self.value(forKey: "name") as? String ?? nil else { return nil }
      guard let bloodType =
         (self.value(forKey: "blood_type") as? String ?? nil)?.convertToBloodType()
         else { return nil }
      guard let email = self.value(forKey: "email") as? String ?? nil else { return nil }
      guard let password = self.value(forKey: "password") as? String ?? nil else { return nil }
      guard let birthdate = self.value(forKey: "birth_date") as? Date ?? nil else { return nil }
      guard let lastDonor = self.value(forKey: "last_donot") as? Date ?? nil else { return nil }

      guard let isVerif = self.value(forKey: "isVerified") as? Int ?? nil else { return nil }
      
      guard let gdr = self.value(forKey: "gender") as? Int ?? nil else { return nil }
      
      let gender = { () -> Gender in
         if gdr == 0 {
            return Gender.female
         } else {
            return Gender.male
         }
      }
      
      let location = self.value(forKey: "location") as? CLLocation
      
      guard let statusDonor = self.value(forKey: "donor_status") as? Int ?? nil else { return nil }
      
      let userModel = UserModel(idUser: self.recordID,
                                name: name,
                                location: location,
                                bloodType: bloodType,
                                statusDonor: (statusDonor == 1),
                                email: email,
                                password: password,
                                birthdate: birthdate,
                                lastDonor: lastDonor,
                                gender: gender(),
                                isVerified: (isVerif == 1))
      return userModel
   }
   
//   func convertUTDToUTDModel () -> UTDModel? {
//      guard let name = self.value(forKey: "name") as? String ?? nil else { return nil }
//      guard let address = self.value(forKey: "address") as? String ?? nil else { return nil }
//      guard let location = self.value(forKey: "location" as? CLLocation ?? nil) else { return nil }
//      let phone = self.value(forKey: "telephone") as? String ?? nil
//      
//      
//      let utdModel = UTDModel(idUTD: self.recordID,
//                              name: name,
//                              address: address,
//                              location: location,
//                              phone: <#T##[String]?#>,
//                              province: <#T##String#>)
//   }
}
