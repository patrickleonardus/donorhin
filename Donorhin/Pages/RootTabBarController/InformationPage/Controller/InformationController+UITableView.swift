//
//  InformationController+UITableView.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import WebKit

extension InformationController : UITableViewDelegate{
    
}

extension InformationController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 8
  }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      var height : CGFloat = 0
      
      if infoItems != nil {
        guard let data = infoItems?[indexPath.section] else {fatalError()}
        
        if data.type == .video {
          height = 380
        }
          
        else if data.type == .text {
          
          if navigationBarTitle == "Kontak UTD PMI"{
            if indexPath.section == 0 {
              height = 460
            }
            else {
              height = 580
            }
          }
            
          else if navigationBarTitle == "Cara Penggunaan Aplikasi" {
            if indexPath.section == 1 {
              height = 360
            }
            else {
              height = 240
            }
          }
          
          else if navigationBarTitle == "Daftar Syarat Pendonor"{
            if indexPath.section == 0 {
              height = 400
            }
            else {
              height = 420
            }
          }
          
          else if navigationBarTitle == "Info Umum"{
            if indexPath.section == 0 {
              height = 560
            }
            else {
              height = 400
            }
          }
          
          else if navigationBarTitle == "Apa Itu Koordinator?"{
            if indexPath.section == 0 {
              height = 560
            }
            else {
              height = 460
            }
          }
          
        }
      }
      
      else {
        height = 300
      }
     
      return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      
      if infoItems != nil {
         return infoItems!.count
      }
      else {
        return 1
      }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      
      
      if infoItems != nil  {
        
         let cell  = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InformationTableViewCell
        
        //masukin datanya
        guard let data = infoItems?[indexPath.section] else {fatalError()}
        
        cell?.titleLabel.text = data.title
        
        cell?.layer.backgroundColor = UIColor.white.cgColor
        cell?.layer.cornerRadius = 10
        
        //ini buat bikin linespacing antar text jadi lebih tinggi
        guard let string = data.longText else {fatalError()}
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStryle = NSMutableParagraphStyle()
        paragraphStryle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStryle, range: NSMakeRange(0, attrString.length))
        cell?.longTextLabel.attributedText = attrString
        
        cell?.longTextLabel.changeFont(ofText: "mem-posting", with: UIFont.italicSystemFont(ofSize: 16))
        cell?.longTextLabel.changeFont(ofText: "di-posting", with: UIFont.italicSystemFont(ofSize: 16))
        cell?.longTextLabel.changeFont(ofText: "direct message", with: UIFont.italicSystemFont(ofSize: 16))
        
        
        if data.type == .text {
          cell?.videoLayer.isHidden = true
          cell?.titleLabel.isHidden = false
          cell?.longTextLabel.isHidden = false
          cell?.firstContactLabel.isHidden = true
          cell?.firstContactButton.isHidden = true
          cell?.secondContactLabel.isHidden = true
          cell?.secondContactButton.isHidden = true
          
          if navigationBarTitle == "Kontak UTD PMI" {
            if indexPath.section == 1 {
              cell?.firstContactLabel.isHidden = false
              cell?.firstContactButton.isHidden = false
              cell?.secondContactLabel.isHidden = false
              cell?.secondContactButton.isHidden = false
              
              cell?.firstContactLabel.text = "Link website daftar kontak UTD PMI :"
              cell?.firstContactButton.setTitle("http://ayodonor.pmi.or.id/table.php", for: .normal)
              cell?.firstContactButton.addTarget(self, action: #selector(linkOpen), for: .touchUpInside)
              cell?.secondContactLabel.text = "Hubungi tim donorhin melalui Instagram :"
              cell?.secondContactButton.setTitle("@donorhin.id", for: .normal)
              cell?.secondContactButton.addTarget(self, action: #selector(instagramOpen), for: .touchUpInside)
            }
          }
          else if navigationBarTitle == "Apa Itu Koordinator?" {
            if indexPath.section == 0 {
              cell?.firstContactLabel.isHidden = false
              cell?.firstContactButton.isHidden = false
              
              cell?.firstContactLabel.text = "Hubungi tim donorhin melalui Instagram :"
              cell?.firstContactButton.setTitle("@donorhin.id", for: .normal)
              cell?.firstContactButton.addTarget(self, action: #selector(instagramOpen), for: .touchUpInside)
            }
          }
          else if  navigationBarTitle == "Cara Penggunaan Aplikasi" {
            if indexPath.section == 2 {
              cell?.firstContactButton.isHidden = false
              cell?.secondContactButton.isHidden = false
              
              let labelHeight = cell?.firstContactLabel.frame.height
              
              cell?.firstButtonTopConstraint.constant = -labelHeight! - 5
              cell?.secondButtonTopConstraint.constant = -labelHeight!
              
              cell?.firstContactButton.setTitle("Alur proses pencarian pendonor", for: .normal)
              cell?.firstContactButton.addTarget(self, action: #selector(recipientInfo), for: .touchUpInside)
              cell?.secondContactButton.setTitle("Alur proses donor darah", for: .normal)
              cell?.secondContactButton.addTarget(self, action: #selector(donorInfo), for: .touchUpInside)
            }
          }
        }
        else if data.type == .video {
          cell?.titleLabel.isHidden = true
          cell?.longTextLabel.isHidden = true
          cell?.firstContactLabel.isHidden = true
          cell?.firstContactButton.isHidden = true
          cell?.secondContactLabel.isHidden = true
          cell?.secondContactButton.isHidden = true
          cell?.videoLayer.isHidden = false
          
          let url = data.videoURL
          let request = URLRequest(url: URL(string: url!)!)
          cell?.webView.load(request)
          cell?.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
          
        }
        return cell!
      }
      
      else {
         let cell  = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InformationDeveloperContact
        
        cell?.layer.backgroundColor = UIColor.white.cgColor
        cell?.layer.cornerRadius = 10
        
        cell?.titleLabel.text = "Kontak Tim Donorhin"
        
        cell?.firstLabel.text = "Hubungi kami melalui direct message Instagram :"
        cell?.firstButton.setTitle("@donorhin.id", for: .normal)
        cell?.firstButton.addTarget(self, action: #selector(instagramOpen), for: .touchUpInside)
        
        cell?.secondLabel.text = "Hubungi kami melalui Whatsapp :"
        cell?.secondButton.setTitle("✆ 081317019898", for: .normal)
        cell?.secondButton.addTarget(self, action: #selector(whatsappOpen), for: .touchUpInside)
        
        
        return cell!
      }
      
    }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
     let cell  = sectionTable.dequeueReusableCell(withIdentifier: "infoCell") as? InformationTableViewCell
    
    if keyPath == "loading" {
      if (cell?.webView.isLoading)! {
        DispatchQueue.main.async {
          cell?.activityIndicator.startAnimating()
          cell?.activityIndicator.isHidden = false
        }
        
      }
      else {
        DispatchQueue.main.async {
          cell?.activityIndicator.stopAnimating()
          cell?.activityIndicator.isHidden = true
        }
        
      }
    }
    
  }

}
