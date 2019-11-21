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
    @IBOutlet weak var viewValidation: CustomMainView!
    
    
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
        setValidation()
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
    
    private func setValidation(){
        
        let checkLogin = UserDefaults.standard.string(forKey: "currentUser")
        if checkLogin != nil {
            viewValidation.alpha = 0
        }
        else if checkLogin == nil {
            viewValidation.alpha = 1
        }

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
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
}

