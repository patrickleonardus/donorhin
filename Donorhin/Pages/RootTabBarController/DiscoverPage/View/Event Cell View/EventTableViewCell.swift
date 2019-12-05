//
//  EventCellDiscover.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell{
  
  var eventData : [EventModel]?
  var moveToAddEventDelegate : MoveToAddEvent?
  var moveToDetailEventDelegate : MoveToEventDetail?
  
  @IBOutlet weak var collectionViewDiscover: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.collectionViewDiscover.delegate = self
    self.collectionViewDiscover.dataSource = self
    
    loadData()
    
  }
  
  func loadData(){
    EventModelCollectionView().getData { (eventData) in
      
      DispatchQueue.main.async {
        
        self.eventData = eventData
        
        self.eventData?.reverse()
        
        self.collectionViewDiscover.reloadData()
      }
    }
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

