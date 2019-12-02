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
  
  @IBOutlet var addressSV: UIStackView!
  @IBOutlet var dateSV: UIStackView!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        
        status.textColor = Colors.green
      self.layer.borderWidth=4
      self.layer.borderColor = UIColor.red.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
