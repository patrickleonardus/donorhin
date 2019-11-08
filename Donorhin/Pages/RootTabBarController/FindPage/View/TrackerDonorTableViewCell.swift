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
   @IBOutlet var stackView: UIStackView!
   @IBOutlet var informationText: UILabel!
   @IBOutlet var buttonText: UIButton!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      self.generalStyling()
      // Initialization code
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   func generalStyling() {
      self.contentView.layer.cornerRadius = 10
      redCircle.layer.cornerRadius = redCircle.frame.size.height/2
      buttonText.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
   }
   
   //MARK: Use this to styling the cells
   func setupView(status:Status,number:Int) {
      
      let hide = false
      //MARK: Done and Active Styling informationText and buttonText
      if status !=  .toDo { //enable ; on going/done  processes
         self.redCircle.backgroundColor = Colors.red
         
         self.informationText.textColor = .black
         self.buttonText.tintColor = Colors.red
         self.buttonText.titleLabel?.textColor = Colors.red
         self.buttonText.isEnabled = true
         
         //MARK: Done Styling
         if status == .done { //tampilin checklist
            self.checkMarkImage.isHidden = hide
            self.active_label.isHidden =  !hide
            self.active_number.isHidden = !hide
            self.number.isHidden = !hide
            
         //MARK: Active Styling
         } else { //tampilin angka dan aktif
            self.active_label.isHidden =  hide
            self.active_number.isHidden = hide
            self.active_number.text = "\(number)"
            self.number.isHidden = !hide
            self.checkMarkImage.isHidden = !hide
         }
         
      //MARK: To Do Styling
      } else { //to do
         self.redCircle.backgroundColor = Colors.gray_disabled
         
         self.informationText.textColor = Colors.gray_disabled
         self.buttonText.tintColor = Colors.gray_disabled
         self.buttonText.titleLabel?.textColor = Colors.gray_disabled
         self.buttonText.isHidden = true
         
         self.number.isHidden = hide
         self.number.text =  "\(number)"
         self.active_label.isHidden =  !hide
         self.active_number.isHidden = !hide
         self.checkMarkImage.isHidden = !hide
      }
      if number == 4 {
         stylingNumber4(status: status)
      }
      
   }
   
//   func stylingNumber4(status:Status) {
//      self.buttonText.setImage(nil, for: .normal)
////      buttonText.isHidden = false
//      if status == .toDo {
//         self.buttonText.setTitleColor(.white, for: .normal)
//         self.buttonText.backgroundColor = Colors.gray_disabled
//         self.buttonText.frame.size = CGSize(width: 118, height: 43)
//         //self.buttonText.titleLabel!.textColor = Colors.gray_disabled
//         //self.buttonText.titleLabel?.tintColor = Colors.gray_disabled
//         self.buttonText.isEnabled = false
//
//      }
//   }
   
//   func stylingNumber4(status:Status) {
//         self.buttonText.setImage(nil, for: .normal)
//      let confirmButton: UIButton = UIButton()
//         if status == .toDo {
//            self.buttonText.setTitleColor(.white, for: .normal)
//            self.buttonText.backgroundColor = Colors.gray_disabled
//            self.buttonText.frame.size = CGSize(width: 118, height: 43)
//            //self.buttonText.titleLabel!.textColor = Colors.gray_disabled
//            //self.buttonText.titleLabel?.tintColor = Colors.gray_disabled
//            self.buttonText.isEnabled = false
//
//         }
//      }
   
   func stylingNumber4(status:Status) {
      let confirmButton = CustomButtonRounded(frame: CGRect(x: 0, y: 0, width: 118, height: 43))
      confirmButton.setTitle("Konfirmasi", for: .normal)
      confirmButton.setTitleColor(.white, for: .normal)
      confirmButton.layer.cornerRadius = 10
      confirmButton.addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 118))
//      confirmButton.addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 43))
//      confirmButton.titleLabel?.attributedText = NSAttributedString(
      if status == .toDo {
         confirmButton.backgroundColor = Colors.gray_disabled
      } else {
         confirmButton.backgroundColor = Colors.red
      }
//       stackView.addSubview(confirmButton)
      stackView.alignment = .top
      stackView.distribution = .equalSpacing
      stackView.addArrangedSubview(confirmButton)
      stackView.layoutIfNeeded()
//      self.addSubview(confirmButton)
   
      print (confirmButton.frame.size.height)
      print (confirmButton.frame.size.width)
      
      
      //Setting constraint for confirm button
      
      
   }
   
}

