//
//  SecondStepTableViewController.swift
//  Donorhin
//
//  Created by Idris on 12/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
   func handleDatePickerData(picker: UIDatePicker)
}

class SecondStepTableViewController: UITableViewController {
   
   private var picker = UIDatePicker()
   public var delegate: DatePickerDelegate?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupDatePicker()
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
      if indexPath.row == 0 {
         cell.textLabel?.text = "Tanggal Kebutuhan"
         cell.accessoryView = UIImageView(image: UIImage(named: "calendar20"))
      } else {
         cell.textLabel?.text = "Lokasi UTD Mendonor"
         cell.accessoryType = .disclosureIndicator
      }
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(indexPath.row)
      if  indexPath.row == 0 {
         self.delegate?.handleDatePickerData(picker:self.picker)
         //TODO: Date picker harus ditampilin di parentnya table view controller ini a.k.a tampilan penuh dari Step 2. Ntar pake self.view.addSubview(picker) & self.view.bringSubviewToFront(picker)
      }  else if indexPath.row == 1 {
         performSegue(withIdentifier: "GoToUTD", sender: nil)
      }
   }
   
//   editaction
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "GoToUTD" {
         let utdVC = segue.destination as! UTDDonorTableViewController
         utdVC.delegate = self
      }
   }
   
   
   //MARK: Styling date picker
   func setupDatePicker() {
       picker.datePickerMode = .date
      picker.backgroundColor = .white

       let toolbar = UIToolbar()
       toolbar.barStyle = UIBarStyle.default
       toolbar.isTranslucent = true
      toolbar.backgroundColor = .white
      toolbar.tintColor = Colors.red
       toolbar.sizeToFit()

      /**nambahin toolbar Ini Harusnya di pake di parent view sekalian sama Date Picker Handlers di baris 89
      let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
       doneButton.tintColor = UIColor.black
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
       cancelButton.tintColor = UIColor.black

       toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
       toolbar.isUserInteractionEnabled = true

//       picker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
 */

       //add the picker to your view or tableView if you use UITableViewController
//      self.tableView.addSubview(picker)
//      self.tableView.bringSubview(toFront: picker)
   }
   
   //MARK: Date Picker Handlers: Harusnya di taro di parent view, you can move these line of code below
//   @objc func donePicker () {
//      //TODO: What happened when done button on the picker pressed?
//   }
//   @objc func cancelPicker () {
//      //TODO: What happened when cancel button on the picker pressed?
//   }
//   @objc func handleDatePicker () {
//      //TODO: Handle data from picker here
//   }
//
//   @objc func pickerDoneBtnPressed(sender:UIDatePicker) {
//      //TODO: action when button done on picker pressed
//      print ("Picker button done pressed")
//   }
   
}


extension SecondStepTableViewController: DelegateUTD {
   func seletedUTD(utd: PMIModel?) {
      if let utd = utd {
         self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel!.text = utd.name
         
      }
   }
}
