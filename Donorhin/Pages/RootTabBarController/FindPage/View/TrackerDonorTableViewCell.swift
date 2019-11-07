//
//  TrackerDonorTableViewCell.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 06/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit



class TrackerDonorTableViewCell: UITableViewCell {
   /**
    Note:Pake fungsi setupView setelah manggil cell di Table View.
    */
   
   enum Status {
      case done
      case onGoing
      case toDo
   }
  
   
   @IBOutlet var redCircle: UIView!
   
   @IBOutlet var checkMarkImage: UIImageView!
   @IBOutlet var number: UILabel!
   @IBOutlet var active_number: UILabel!
   @IBOutlet var active_label: UILabel!
   
   @IBOutlet var informationText: UILabel!
   @IBOutlet var buttonText: UIButton!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      self.contentView.layer.cornerRadius = 10
      redCircle.layer.cornerRadius = redCircle.frame.size.height/2
      // Initialization code
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   
   //MARK: Use this to styling the cells
   func setupView(status:Status) {
      switch status {
      case .done:
         doneStyling()
      case .onGoing:
         onGoingStyling()
      case .toDo:
         toDoStyling()
      }
   }
   
   
   //MARK: Done Styling
   func doneStyling() { //with white checkmark and red circle
      self.checkMarkImage.isHidden = !true
      self.number.isHidden = true
      self.active_label.isHidden = true
      self.active_number.isHidden = true
      
      self.redCircle.backgroundColor = Colors.red
      self.informationText.textColor = .black
      
      self.buttonText.tintColor = Colors.red
      self.buttonText.titleLabel?.textColor = Colors.red
      self.buttonText.isEnabled = true
   }
   
   
   //MARK: Ongoing Styling
   func onGoingStyling() {
      self.checkMarkImage.isHidden = true
      self.number.isHidden = true
      self.active_label.isHidden = !true
      self.active_number.isHidden = !true
      
      self.redCircle.backgroundColor = Colors.red
      self.informationText.textColor = .black
      
      self.buttonText.tintColor = Colors.red
      self.buttonText.titleLabel?.textColor = Colors.red
      self.buttonText.isEnabled = true
   }
   
   
   //MARK: To Do Styling
   func toDoStyling() {
      let hide = true
      self.checkMarkImage.isHidden = hide
      self.number.isHidden = !hide
      self.active_label.isHidden = hide
      self.active_number.isHidden = hide
      
      self.redCircle.backgroundColor = Colors.gray_disabled
      self.informationText.textColor = Colors.gray_disabled
      
      self.buttonText.tintColor = Colors.gray_disabled
      self.buttonText.titleLabel?.textColor = Colors.gray_disabled
      self.buttonText.isEnabled = false

   }
   
   
   
   
   
   
   
   
}
