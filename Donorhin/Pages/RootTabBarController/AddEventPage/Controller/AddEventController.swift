//
//  AddController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class AddEventController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Setup UI
    
    private func setNavBar(){
        let cancel = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = cancel
    }
    
    @objc private func cancelAction(){
        dismiss(animated: true, completion: nil)
    }

}
