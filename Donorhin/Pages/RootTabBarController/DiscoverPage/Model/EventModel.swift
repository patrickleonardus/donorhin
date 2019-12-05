//
//  EventModel.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

struct EventModel {
    let image : UIImage?
    let title : String?
    let description : String?
    let address : String?
    let startDate : Date?
    let endDate : Date?
    let nameEvent : String?
    let phoneEvent : String?
}

struct EventModelCollectionView {
    
    func getData(completionHandler : @escaping (([EventModel]) -> ())){
        
        DispatchQueue.main.async {
            var eventData : [EventModel] = []
            
            var image : UIImage?
            var title : String?
            var description : String?
            var address : String?
            var startDate : Date?
            var endDate : Date?
            var nameEvent : String?
            var phoneEvent : String?
            
            let query = CKQuery(recordType: "Event", predicate: NSPredicate(value: true))
          query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
          
            Helper.getAllData(query) { (results) in
                guard let results = results else {fatalError("Query error")}
                
                for result in results {
                    let models = result.convertEventToEventGlobalModel()
                    guard let model = models else {fatalError("Model error")}
                    
                    image = model.image
                    title = model.title
                    description = model.description
                    address = model.address
                    startDate = model.startTime
                    endDate = model.endTime
                    nameEvent = model.cpName
                    phoneEvent = model.cpPhone
                    
                    eventData.append(EventModel(image: image, title: title, description: description, address: address, startDate: startDate, endDate: endDate, nameEvent: nameEvent, phoneEvent: phoneEvent))
                }
                completionHandler(eventData)
            }
        }
    }
}
