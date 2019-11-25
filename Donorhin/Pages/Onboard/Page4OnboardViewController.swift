//
//  Page1ViewController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit


class Page4ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UDDevice.widthScreen < 400 {
            label1.font = label1.font.withSize(17)
            label2.font = label2.font.withSize(17)
            label3.font = label3.font.withSize(17)

        }
    }
    
    @IBAction func masukAkunButton(_ sender: Any) {
        performSegue(withIdentifier: "goToAuthentication", sender: self)
    }
    @IBAction func masukNantiButton(_ sender: Any) {
        performSegue(withIdentifier: "goToRootTabBarController", sender: self)
    }
    
    
}
