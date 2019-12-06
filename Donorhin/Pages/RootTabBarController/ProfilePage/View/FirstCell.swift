//
//  FirstCell.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class FirstCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        //MARK: -SET PROFILE IMAGE
        imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.backgroundColor = Colors.backgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
