//
//  ProfileController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
    
class ProfileController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user : Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ProfileDataFetcher().getProfileFromUserDefaults { (profileData) in
            self.user = profileData
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI(){
        tableView.tableFooterView = UIView()
        setNavigationButton()
    }
    
    private func setNavigationButton(){
        let doneButton = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    //MARK: -Action
    // dissmiss modal view
    @objc private func doneAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logoutAction(){
        print("logout tapped")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "authStoryboard") as! LoginController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
}

