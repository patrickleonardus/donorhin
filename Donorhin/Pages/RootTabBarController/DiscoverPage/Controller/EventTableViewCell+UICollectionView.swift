//
//  EventCellDiscover+UICollectionView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension EventTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numberOfItemsInSection = 0
        
        if section == 0 {
            numberOfItemsInSection = 1
        }
        else if section == 1 {
            if eventData == nil {
                numberOfItemsInSection = 1
            }
            else if eventData != nil {
                 numberOfItemsInSection = eventData!.count
            }
        }
        
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addEventCV", for: indexPath) as! AddEventCollectionViewCell
            
            cell.labelTitle.text = "Tambahkan acara baru"
            
            //setup ui cell
            
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 10
            
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCV", for: indexPath) as! EventListCollectionViewCell
            
            if eventData == nil {
                cell.imageEvent.contentMode = UIView.ContentMode.scaleAspectFill
                cell.imageEvent.image = UIImage(named: "user_profile")
                cell.titleEvent.text = "Mohon Tunggu"
                cell.addressEvent.text = "Data sedang di proses"
                cell.dateEvent.text = ""
            }
            
            else if eventData != nil {
                guard let data = eventData?[indexPath.row] else {fatalError()}
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                let startDateCast = dateFormatter.string(from: data.startDate!)
                
                cell.imageEvent.contentMode = UIView.ContentMode.scaleAspectFill
                
                cell.imageEvent.image = data.image
                cell.titleEvent.text = data.title
                cell.addressEvent.text = data.address
                cell.dateEvent.text = startDateCast

            }
            
            //setup ui cell
            
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 10
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if indexPath.section == 0 {
            self.moveToAddEventDelegate?.moveToAddEventClass()
        }
        else {
            
            if eventData == nil {
                print("Data has not load yet")
            }
            
            else if eventData != nil {
                guard let data = eventData?[indexPath.row] else {fatalError()}
                self.moveToDetailEventDelegate?.moveToAddEventDetailClass(image: data.image!, title: data.title!, desc: data.description!, address: data.address!, date: data.startDate!, name: data.nameEvent!, phone: data.phoneEvent!)
            }
        }
    }
}
