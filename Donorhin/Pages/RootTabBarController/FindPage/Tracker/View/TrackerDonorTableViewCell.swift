//
//  TrackerDonorTableViewCell.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 06/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

protocol TrackerCellDelegate {
   func didConfirmed ()
   func showMoreInfo()
}

class TrackerDonorTableViewCell: UITableViewCell {
   /**
    Note:Pake fungsi setupView setelah manggil cell di Table View.
    */
   var delegate : TrackerCellDelegate?
   
   
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
   @IBOutlet var buttonMoreInfo : UIButton!
   
   let confirmButton = CustomButtonRounded(frame: CGRect(x: 0, y: 0, width: 118, height: 43))
   var phoneNumber : String?
   
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
      buttonText.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
      
      //      add width constraint for red circle
      let width : CGFloat
      if UDDevice.widthScreen < 375 {
         width = 50
      } else {
         width = 62
      }
      let heightConstraint = NSLayoutConstraint( item: self.redCircle!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width)
      redCircle.addConstraint(heightConstraint)
      redCircle.layer.cornerRadius = width/2
      redCircle.layoutIfNeeded()
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
      else if number == 1 || number == 2 {
         self.buttonText.isHidden = false
      } else {
         self.buttonText.isHidden = true
      }
      if number == 5 {
         stylingNo5(status:status)
      } else {
         self.buttonMoreInfo.isHidden = true
      }
   }
   
   func stylingNo5(status:Status){
      self.buttonText.isHidden = true
      self.buttonMoreInfo.isHidden = false
      redCircle.backgroundColor = Colors.red
      active_number.text = "i"
      number.text = "i"
      informationText.textColor = UIColor.black
      buttonMoreInfo.setTitle("Lihat info lengkap", for: .normal)
      buttonMoreInfo.setTitleColor(Colors.red, for: .normal)
      buttonMoreInfo.isEnabled = true
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
         if status == .done {
            confirmButton.isHidden = true
            informationText.text = "Anda telah mengkonfirmasi bahwa Anda sudah mendapatkan kantong darah. Semoga  sehat selalu!"
         }
      }
      
      //embedding to stackview
      stackView.alignment = .leading
      stackView.distribution = .fillProportionally
      stackView.arrangedSubviews[1].removeFromSuperview()//so it won't repeat adding the same
      stackView.insertArrangedSubview(confirmButton, at: 1)
   }
   
   //MARK: Button confirm pressed
   @objc func buttonConfirmedPressed(_ sender: UIButton) { //for confirmButton
      //TO DO: add  action confirm
      self.delegate?.didConfirmed()
      self.confirmButton.isHidden = true
   }
   
   @IBAction func buttonMoreInfoPressed(_ sender: UIButton) {
      delegate?.showMoreInfo()
   }
   
}

