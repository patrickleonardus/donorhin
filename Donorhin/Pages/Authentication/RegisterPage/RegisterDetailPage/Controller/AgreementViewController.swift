//
//  AgreementViewController.swift
//  Donorhin
//
//  Created by Idris on 22/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class AgreementViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Persetujuan penggunaan aplikasi"
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = UIColor.clear
  }
}

extension AgreementViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 18
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    var title  = ""
    
    if section == 1 {
      title = ""
    }
    else if section == 2 {
      title = ""
    }
    
    return title
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    var height : CGFloat = 0
    
    if indexPath.section == 0 {
        height = 250
    }
    else if indexPath.section == 1 {
        height = 340
    }
    else if indexPath.section == 2 {
        height = 150
    }
    return height
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var number = 0
    
    if section == 0 {
      number = 1
    }
    else if section == 1 {
      number = 1
    }
    else if section == 2 {
      number = 1
    }
    return number
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "firstTableViewCell") as! FirstTableViewCell
      cell.backgroundColor = UIColor.white
      cell.layer.cornerRadius = 10
      cell.imageAgreement.image = UIImage(named: "agreement")
      cell.titleAgreement.text = "Donorhin dan Privasi"
      return cell
    }
    else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableViewCell") as! SecondTableViewCell
      cell.backgroundColor = UIColor.white
      cell.layer.cornerRadius = 10
      
      let string = "Data pengguna tidak dapat dilihat oleh  resipien (pencari donor) atau pendonor  (donatur darah). Hal ini dilakukan untuk menjaga privasi pengguna serta meminimalisir penjualan darah. Proses  verifikasi kebutuhan darah resipien dilakukan oleh pendonor dengan menanyakan PMI dimana resipien memberikan surat.  Resipien perlu untuk memberikan surat  keterangan butuh darah ke PMI agar proses  verifikasi oleh pendonor berhasil."
      
      let attrString = NSMutableAttributedString(string: string)
      let paragraphStryle = NSMutableParagraphStyle()
      paragraphStryle.lineSpacing = 5
      attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStryle, range: NSMakeRange(0, attrString.length))
      cell.longText.attributedText = attrString
      
      return cell
    }
    else if indexPath.section == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "thirdTableViewCell") as! SecondTableViewCell
      
      let string = "Selalu menghidupkan lokasi untuk aplikasi Donorhin perlu dilakukan karena Donorhin membutuhkan hal tersebut pada saat pencarian donor terdekat."
      
      let attrString = NSMutableAttributedString(string: string)
      let paragraphStryle = NSMutableParagraphStyle()
      paragraphStryle.lineSpacing = 5
      attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStryle, range: NSMakeRange(0, attrString.length))
      cell.longText.attributedText = attrString
      
      cell.backgroundColor = UIColor.white
      cell.layer.cornerRadius = 10
      return cell
    }
    
   
    return UITableViewCell()
  }
  
}
