//
//  InformationController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class InformationController : UIViewController {
    
    @IBOutlet weak var sectionTable: UITableView!
    
    var infoItems : [InfoItems]?
    var navigationBarTitle : String?
    var navigationBarTitleInfo : String?
    var sectionTotal : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarTitle()
        self.view.backgroundColor = Colors.backgroundView
        if navigationBarTitle == "Kontak UTD PMI"{
            InfoData().getInfoCommunity { (infoItems) in
            self.infoItems = infoItems
            self.loadTableView()
            }
        }
        else if navigationBarTitle == "Daftar Syarat Pendonor" {
            InfoData().getInfoSyaratPendonor { (infoItems) in
            self.infoItems = infoItems
            self.loadTableView()
            }
        }
        else if navigationBarTitle == "Cara Penggunaan Aplikasi" {
            InfoData().getInfoWithVideo { (infoItems) in
            self.infoItems = infoItems
            self.loadTableView()
            }
        }
        else if navigationBarTitle == "Info Umum" {
            InfoData().getInfoUTD { (infoItems) in
            self.infoItems = infoItems
            self.loadTableView()
          }
        }
        else if navigationBarTitle == "Apa Itu Koordinator?" {
          InfoData().getInfoKoordinator { (infoItems) in
            self.infoItems = infoItems
            self.loadTableView()
          }
      }
        else if navigationBarTitle == "Hubungi Donorhin" {
          self.loadTableViewDev()
      }
      
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
    if segue.identifier == "moveToDonorInfo" {
      let destination = segue.destination as! DonorInfoController
      destination.navigationTitle = navigationBarTitleInfo
    }
    else if segue.identifier == "unwindToDiscover" {
      
    }
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
    sectionTable.register(UINib(nibName: "InformationDeveloperContact", bundle: nil), forCellReuseIdentifier: "infoCell")
    sectionTable.tableFooterView = UIView()
    sectionTable.reloadData()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setTabBar(show: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      
      if self.isMovingFromParent {
        
        if let vcs = self.navigationController?.viewControllers {
          let previousVC = vcs[vcs.count - 1]
          if previousVC is DiscoverController {
              self.performSegue(withIdentifier: "unwindToDiscover", sender: self)
          }
          else if previousVC is DonateStepViewController {
            print("sebelumnya first step")
          }
          else if previousVC is TrackerController {
            print("sebelumnya tracker")
          }
        }
        
      }
      
      
    }
    
    func setNavBarTitle(){
        navigationItem.title = navigationBarTitle
    }
    
    func setTabBar(show: Bool){
        if show {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 1
            }
        }
        else {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 0
            }
        }
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
  
  @objc func whatsappOpen(){
    let phoneNumber =  "+6281317019898" // you need to change this number
    let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
    
    if UIApplication.shared.canOpenURL(appURL) {
      UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
    }
  }
  
  @objc func linkOpen(){
    UIApplication.shared.open(URL(string: "http://ayodonor.pmi.or.id/table.php")!, options: [:], completionHandler: nil)
  }
  
  @objc func donorInfo(){
    navigationBarTitleInfo = "Info Pendonor"
    performSegue(withIdentifier: "moveToDonorInfo", sender: self)
  }
  
  @objc func recipientInfo(){
    navigationBarTitleInfo = "Info Resipien"
    performSegue(withIdentifier: "moveToDonorInfo", sender: self)
  }
}
