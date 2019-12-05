//
//  EventCellDiscover+UICollectionView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension EventTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    var edgeInsets = UIEdgeInsets()
    
    if section == 0 {
      edgeInsets.left = 20
    }
    else {
      edgeInsets.left = 20
      edgeInsets.right = 20
    }
    
    return edgeInsets
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
              cell.titleEvent.textAlignment = .center
                cell.addressEvent.text = ""
                cell.dateEvent.text = "Data sedang di proses"
              cell.dateEvent.textAlignment = .center
              cell.publisherEvent.text = ""
            }
            
            else if eventData != nil {
                guard let data = eventData?[indexPath.row] else {fatalError()}
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                let startDateCast = dateFormatter.string(from: data.startDate!)
                
                cell.imageEvent.contentMode = UIView.ContentMode.scaleAspectFill
                
                cell.imageEvent.image = data.image
                cell.titleEvent.text = data.title
               cell.titleEvent.textAlignment = .left
                cell.addressEvent.text = data.address
                cell.dateEvent.text = startDateCast
               cell.dateEvent.textAlignment = .left
              cell.publisherEvent.text = "Ditulis Oleh: \(String(describing: data.nameEvent!))"

            }
            
            //setup ui cell
            
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 10
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currUser = UserDefaults.standard.string(forKey: "currentUser")
        
        if indexPath.section == 0 {
          
          if currUser == nil {
            let alert = UIAlertController(title: "Anda belum login", message: "Untuk mengakses fitur ini, anda perlu untuk melakukan login terlebih dahulu, apakah anda ingin Login?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Nanti Saja", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login Sekarang", style: .default, handler: { (action) in
              self.moveToLogin?.performLogin()
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
          }
            
          else if currUser != nil {
            self.moveToAddEventDelegate?.moveToAddEventClass()
          }
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
