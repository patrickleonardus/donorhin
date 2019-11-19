//
//  EventCellDiscover.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var eventData : [EventModel]?
    var moveToAddEventDelegate : MoveToAddEvent?
    var moveToDetailEventDelegate : MoveToEventDetail?
    
    @IBOutlet weak var collectionViewDiscover: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        DummyDataForEvent().getEventData { (eventData) in
            self.eventData = eventData
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
