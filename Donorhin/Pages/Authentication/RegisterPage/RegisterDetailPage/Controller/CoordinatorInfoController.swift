//
//  CoordinatorInfoController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 09/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import AVKit

class CoordinatorInfoController : UIViewController {
    
    @IBOutlet weak var sectionTable: UITableView!
    var infoItems : [InfoItems]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apa Itu Koordinator?"
        
        let done = UIBarButtonItem(title: "Selesai", style: .done, target: self, action: #selector(doneAction))
        
        navigationItem.leftBarButtonItem = done
        InfoData().getInfoKoordinator { (infoItems) in
          self.infoItems = infoItems
        }
        self.view.backgroundColor = Colors.backgroundView
        loadTableView()
        loadTableViewDev()
    }
    
    @objc func doneAction(){
      dismiss(animated: true, completion: nil)
    }
    
    func loadTableView() {
        sectionTable.delegate = self
        sectionTable.backgroundColor = Colors.backgroundView
        sectionTable.dataSource = self
        sectionTable.register(UINib(nibName: "InformationCustomCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        sectionTable.tableFooterView = UIView()
        sectionTable.reloadData()
    }
    
    func loadTableViewDev(){
      sectionTable.delegate = self
      sectionTable.dataSource = self
      sectionTable.backgroundColor = Colors.backgroundView
      sectionTable.register(UINib(nibName: "InformationDeveloperContact", bundle: nil), forCellReuseIdentifier: "infoDevCell")
      sectionTable.tableFooterView = UIView()
      sectionTable.reloadData()
    }
    
    @objc func instagramOpen(){
      let instagramHooks = "instagram://user?username=donorhin.id"
      let instagramUrl = NSURL(string: instagramHooks)
      let instagramBrowser = NSURL(string: "https://www.instagram.com/donorhin.id/?igshid=kf6rbyke1m4z")
      if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
        
        UIApplication.shared.open(instagramUrl! as URL, options: [:], completionHandler: nil)
        
      } else {
        //redirect to safari because the user doesn't have Instagram
        UIApplication.shared.open(instagramBrowser! as URL, options: [:], completionHandler: nil)
      }
    }
}

extension CoordinatorInfoController : UITableViewDelegate, UITableViewDataSource {
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
        
        guard let data = infoItems?[indexPath.section] else {fatalError()}
        
        if data.type == .video {
          if indexPath.section == 0 {
            height = 200
          }
          else if indexPath.section == 1 {
            height = 460
          }
          else if indexPath.section == 2 {
            height = 400
          }
        }
        
        else if data.type == .text {
          if indexPath.section == 0 {
            height = 560
          }
          else {
            height = 460
          }
        }
      
        return height
      }
      
      func numberOfSections(in tableView: UITableView) -> Int {
        return infoItems!.count
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        }
        
          cell?.firstContactLabel.isHidden = false
          cell?.secondContactLabel.isHidden = true
          cell?.firstContactButton.isHidden = false
          cell?.firstContactLabel.text = "Hubungi tim donorhin melalui Instagram :"
          cell?.firstContactButton.setTitle("@donorhin.id", for: .normal)
          cell?.firstContactButton.addTarget(self, action: #selector(instagramOpen), for: .touchUpInside)
        
          return cell!
      }
}
