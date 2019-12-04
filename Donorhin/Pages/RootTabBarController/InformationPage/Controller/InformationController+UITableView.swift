//
//  InformationController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import AVKit

extension InformationController : UITableViewDelegate{
    
}

extension InformationController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 8
  }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      var height : CGFloat = 0
      
      if indexPath.section == 0 {
        height = 200
      }
      else {
        height = 400
      }
      
      return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return infoItems!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InformationTableViewCell
        //masukin datanya
        guard let data = infoItems?[indexPath.section] else {fatalError()}
        
        cell?.titleLabel.text = data.title
      
      cell?.layer.backgroundColor = UIColor.white.cgColor
      cell?.layer.cornerRadius = 10
      
      //ini buat bikin linespacing antar text jadi lebih tinggi
      guard let string = data.longText else {fatalError()}
      let attrString = NSMutableAttributedString(string: string)
      let paragraphStryle = NSMutableParagraphStyle()
      paragraphStryle.lineSpacing = 5
      attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStryle, range: NSMakeRange(0, attrString.length))
      cell?.longTextLabel.attributedText = attrString
      
        if data.type == .text {
            cell?.videoLayer.isHidden = true
            cell?.titleLabel.isHidden = false
            cell?.longTextLabel.isHidden = false
        }
        else if data.type == .video {
            cell?.titleLabel.isHidden = true
            cell?.longTextLabel.isHidden = true
            cell?.videoLayer.isHidden = false

            let videoURL = URL(string: data.videoURL!)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = AVLayerVideoGravity.resize
            playerLayer.frame = cell!.videoLayer.bounds
            cell?.videoLayer.layer.addSublayer(playerLayer)
        }
        
        return cell!
    }
}
