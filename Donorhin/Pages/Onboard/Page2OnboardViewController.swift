//
//  Page1ViewController.swift
//  Donorhin
//
//  Created by Ni Made Ananda Ayu Permata on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit


class Page2ViewController: UIViewController {

    
    @IBOutlet weak var lacakLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK : - CHANGE FONT SIZE
        if UDDevice.widthScreen < 400 {
            lacakLabel.font = lacakLabel.font.withSize(17)
        }
    }
}
