//
//  EventCellDiscover.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class EventTableViewCell: UITableViewCell{
  
  var eventData : [EventModel]?
  var user : [UserModel] = []
  var moveToAddEventDelegate : MoveToAddEvent?
  var moveToDetailEventDelegate : MoveToEventDetail?
  var alertDelegate : DiscoverAlert?
  
  @IBOutlet weak var collectionViewDiscover: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.collectionViewDiscover.delegate = self
    self.collectionViewDiscover.dataSource = self
    self.collectionViewDiscover.decelerationRate = UIScrollView.DecelerationRate.fast
    
    loadData()
    checkIsVerified()
  }
  
  func loadData(){
    EventModelCollectionView().getData { (eventData) in
      
      DispatchQueue.main.async {
        
        self.eventData = eventData
        
        self.collectionViewDiscover.reloadData()
      }
    }
  }
  
  func checkIsVerified(){
    
    user.removeAll()
    
    let userId = UserDefaults.standard.string(forKey: "currentUser")
    
    if userId == nil {
      print("User has'nt login yet")
    }
    else if userId != nil {
      guard let uid = userId else {return}
      let ckRecordUID = CKRecord.ID(recordName: uid)
      
      Helper.getDataByID(ckRecordUID) { (results) in
        
        if let result = results {
         
          let models = result.convertAccountToUserModel()
          guard let model = models else {fatalError("User data not found")}
          
          self.user.append(UserModel(idUser: model.idUser, name: model.name, location: model.location, bloodType: model.bloodType, statusDonor: model.statusDonor, email: model.email, password: model.password, birthdate: model.birthdate, lastDonor: model.lastDonor, gender: model.gender, isVerified: model.isVerified))
          
          DispatchQueue.main.async {
            self.collectionViewDiscover.reloadData()
          }
        }
      }
    }
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

