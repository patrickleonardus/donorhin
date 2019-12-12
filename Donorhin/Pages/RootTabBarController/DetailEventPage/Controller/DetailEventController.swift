//
//  DetailViewController2.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 19/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class DetailEventController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //initialize var
    var imageEvent: UIImage?
    var titleEvent: String?
    var descEvent: String?
    var addressEvent: String?
    var dateEvent: Date?
    var nameEvent: String?
    var phoneEvent: String?
    var postedBy: CKRecord.Reference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        print(postedBy)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
        setTabBar(show: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setTabBar(show: true)
    }
    
    //MARK: - Setup ui
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    func setupTableView(){
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
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
    
    private func callNumber(phoneNumber: String){
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func callButton(){
        callNumber(phoneNumber: phoneEvent!)
    }
    
}
