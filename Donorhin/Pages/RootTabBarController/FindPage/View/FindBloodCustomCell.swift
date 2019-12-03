//
//  findBlood.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FindBloodCustomCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var buttonCallOutlet: CallNumberButton!
  
  @IBOutlet var iconChevron: UIImageView!
  @IBOutlet var backView: UIView!
  @IBOutlet var addressSV: UIStackView!
  @IBOutlet var dateSV: UIStackView!
  @IBOutlet var generalSV: UIStackView!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        
        status.textColor = Colors.green
      self.backView.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
//  func addButtonToSV() {
//    guard let buttonCallOutlet = buttonCallOutlet else { fatalError()}
//    let at = generalSV.arrangedSubviews.count-2
//    generalSV.insertArrangedSubview(buttonCallOutlet, at: at)
//  }
//  func removeButtonCall () {
//    guard let buttonCallOutlet = buttonCallOutlet else { return }
//    buttonCallOutlet.removeFromSuperview()
//  }
    
}
