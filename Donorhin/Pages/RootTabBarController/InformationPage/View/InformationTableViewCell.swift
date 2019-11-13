//
//  TrackerTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import AVKit

class InformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var longTextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var videoLayer: UIView!
    
    var infoType : InfoType?
    var videoURLStr : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if infoType == .text {
            videoLayer.isHidden = true
        }
        else {
            loadVideo()
        }
    }
    
    func loadVideo(){
        let videoURL = URL(string: videoURLStr!)
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        videoLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        player.play()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
