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
   let confirmButton = CustomButtonRounded(frame: CGRect(x: 0, y: 0, width: 118, height: 43))
   var phoneNumber : String? = "082285250866"
   
   override func awakeFromNib() {
      super.awakeFromNib()
      self.generalStyling()
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
   
   //MARK: Styling the cell
   func setupView(status:Status,number:Int) {
      
      let hide = false
      //Done and Active Styling informationText and buttonText
      if status !=  .toDo { //enable ; on going/done  processes
         self.redCircle.backgroundColor = Colors.red
         
         self.informationText.textColor = .black
         self.buttonText.tintColor = Colors.red
         self.buttonText.titleLabel?.textColor = Colors.red
         self.buttonText.isEnabled = true
         
         //Done Styling
         if status == .done { //tampilin checklist
            self.checkMarkImage.isHidden = hide
            self.active_label.isHidden =  !hide
            self.active_number.isHidden = !hide
            
            self.number.isHidden = !hide
            
            //Active Styling
         } else { //tampilin angka dan aktif
            self.active_label.isHidden =  hide
            self.active_number.isHidden = hide
            self.active_number.text = "\(number)"
            self.number.isHidden = !hide
            self.checkMarkImage.isHidden = !hide
         }
         
         //To Do Styling
      } else { //to do
         self.redCircle.backgroundColor = Colors.gray_disabled
         
         self.informationText.textColor = Colors.gray_disabled
         self.buttonText.tintColor = Colors.gray_disabled
         self.buttonText.titleLabel?.textColor = Colors.gray_disabled
         
         self.number.isHidden = hide
         self.number.text =  "\(number)"
         self.active_label.isHidden =  !hide
         self.active_number.isHidden = !hide
         self.checkMarkImage.isHidden = !hide
      }
      
      if number == 4 {stylingNumber4(status: status) }
      if number == 1 || number == 2 {
         self.buttonText.isHidden = false
      } else {
         self.buttonText.isHidden = true
      }
   }
   
   func stylingNumber4(status:Status) {
      //add and styling new button
      confirmButton.addTarget(self, action: #selector(buttonConfirmedPressed(_:)), for: .touchUpInside)
      confirmButton.setTitle("Konfirmasi", for: .normal)
      confirmButton.setTitleColor(.white, for: .normal)
      confirmButton.layer.cornerRadius = 10
      
      //add constraint so  it will keep the size
      confirmButton.addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 118))
      confirmButton.addConstraint(NSLayoutConstraint(item: confirmButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 43))
      
      //styling for different cases
      if status == .toDo {
         confirmButton.backgroundColor = Colors.gray_disabled
         confirmButton.isEnabled = false
      } else {
         confirmButton.backgroundColor = Colors.red
         confirmButton.isEnabled = true
      }
      
      //embedding to stackview
      stackView.alignment = .leading
      stackView.distribution = .fillProportionally
      stackView.arrangedSubviews[1].removeFromSuperview()//so it won't repeat adding the same
      stackView.insertArrangedSubview(confirmButton, at: 1)
   }
   
   //MARK: Button text (call) pressed
   @IBAction func makeACall(_ sender: UIButton) {
      print ("Button text (call UTD) pressed")
      if let redCrossPhone = phoneNumber {
         if let phoneCallURL = URL(string: "telprompt://\(redCrossPhone)") {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
         }
         else {
            print("Invalid phone number")
            //TODO: what to do when the phone enumber is invalid?
         }
      }
      else {
         //TODO: What to do when the phone number is nil?
         print("System do not have this Blood Tranfusion Unit's phone number")
      }
   }
   
   //MARK: Button confirm pressed
   @objc func buttonConfirmedPressed(_ sender: UIButton) { //for confirmButton
      //TO DO: add  action confirm
      print ("Button confirm pressed")
   }
   
   
}

