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
      guard
         let donordate = self.value(forKey: "donor_date") as? Date ?? nil,
         let idpendonor = self.value(forKey: "id_pendonor") as? Reference ?? nil,
         let idrequest = self.value(forKey: "id_request") as? Reference ?? nil,
         let idUTDPendonor = self.value(forKey: "id_UTD_pendonor") as? Reference ?? nil,
         let currentStep = self.value(forKey: "current_step") as? Int ?? nil
         else {
//            fatalError("failed casting data with record ID \(self.recordID)")
            return nil
      }
      let trackerModel = TrackerModel(idTracker: self.recordID,
                                      donorDate: donordate,
                                      idPendonor: idpendonor,
                                      idRequest: idrequest,
                                      idUTDPendonor: idUTDPendonor,
                                      currentStep: currentStep)
      return trackerModel
   }
    
    func convertEmptyTrackerToEmptyTrackerModel() -> EmptyTrackerModel? {
        guard
            let idrequest = self.value(forKey: "id_request") as? Reference ?? nil,
            let currentStep = self.value(forKey: "current_step") as? Int ?? nil
            else {
                //            fatalError("failed casting data with record ID \(self.recordID)")
                return nil
        }
        let trackerModel = EmptyTrackerModel(idTracker: self.recordID,
                                        idRequest: idrequest,
                                        currentStep: currentStep)
        return trackerModel
    }
   
   func convertRequestToRequestModel() -> RequestModel? {
      guard let patientName = self.value(forKey: "patient_name") as? String ?? nil,
         let bloodTypePatient = (self.value(forKey: "patient_blood_type") as? String ?? nil)?.convertToBloodType(),
         let amount = self.value(forKey: "amount") as? Int ?? nil,
         let dateNeed = self.value(forKey: "date_need") as? Date ?? nil,
         let isEmergency = self.value(forKey: "isEmergency") as? Int ?? nil,
         let idUTDPatient = self.value(forKey: "UTD_patient") as? Reference ?? nil,
        let idUser = self.value(forKey: "userId") as? Reference ?? nil
    else {
            return nil
      }
      
      let requestModel = RequestModel(idRequest: self.recordID,
                                      patientName: patientName,
                                      bloodTypePatient: bloodTypePatient,
                                      amount: amount,
                                      dateNeed: dateNeed,
                                      isEmergency: (isEmergency==1),
                                       idUTDPatient: idUTDPatient.recordID,
                                       idUser: idUser.recordID)
      
      return requestModel
   }
   
   func convertEventToEventGlobalModel ()  -> EventGlobalModel?{
      
      guard
         let title = self.value(forKey: "title") as? String ?? nil,
         let description = self.value(forKey: "description") as? String ?? nil,
         let address = self.value(forKey: "address") as? String ?? nil,
         let startTime = self.value(forKey: "start_time") as? Date ?? nil,
         let endTime = self.value(forKey: "end_time") as? Date ?? nil,
         let cpPhone = self.value(forKey: "contact_phone") as? String ?? nil,
         let cpName = self.value(forKey: "contact_name") as? String ?? nil,
         let idUser = self.value(forKey: "reference_account") as? Reference ?? nil
         else {
            return nil
      }
      
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
      guard let name = self.value(forKey: "name") as? String ?? nil,
         let bloodType = (self.value(forKey: "blood_type") as? String ?? nil)?.convertToBloodType(),
         let email = self.value(forKey: "email") as? String ?? nil,
         var password = self.value(forKey: "password") as? String ?? nil,
         let birthdate = self.value(forKey: "birth_date") as? Date ?? nil,
         let isVerif = self.value(forKey: "isVerified") as? Int ?? nil,
         let gdr = self.value(forKey: "gender") as? Int ?? nil,
         let statusDonor = self.value(forKey: "donor_status") as? Int ?? nil
         else {
            return nil
      }
        password = try! PasswordCryptor().decryptMessage(encryptedPassword:password)

      let lastDonor = self.value(forKey: "last_donor") as? Date
      let location = self.value(forKey: "location") as? CLLocation
      let gender = { () -> Gender in
         if gdr == 0 {
            return Gender.female
         } else {
            return Gender.male
         }
      }
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
   
   func convertUTDToUTDModel () -> UTDModel? {
      guard
         let name = self.value(forKey: "name") as? String ?? nil,
         let address = self.value(forKey: "address") as? String ?? nil,
         let location = self.object(forKey: "location") as? CLLocation ?? nil,
         let phoneNumbers = self.object(forKey: "telephone") as? NSArray ?? nil,
         let province = self.value(forKey: "province") as? String ?? nil
         else {
          print("Failed while converting UTD to UTD Model\(self)")
            return nil
      }

      var phones : [String]?
      if phoneNumbers.count == 0 {
         phones = nil
      } else {
         phones = []
         for number in phoneNumbers {
            phones?.append(number as? String ?? "")
         }
      }
      
      let utdModel = UTDModel(idUTD: self.recordID,
                              name: name,
                              address: address,
                              location: location,
                              phoneNumbers: phones,
                              province: province)
      return utdModel
   }
}
