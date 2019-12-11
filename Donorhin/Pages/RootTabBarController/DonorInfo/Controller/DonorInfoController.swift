//
//  DonorInfoController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 11/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DonorInfoController: UIViewController {
  
  @IBOutlet weak var infoImage: UIImageView!
  
  var navigationTitle : String?
  var isZooming = false
  var originalImageCenter:CGPoint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = navigationTitle
    
    if navigationTitle == "Info Pendonor" {
      infoImage.image = UIImage(named: "langkah2")
    }
    else if navigationTitle == "Info Resipien" {
      infoImage.image = UIImage(named: "langkah1")
    }
    
    infoImage.isUserInteractionEnabled = true
    originalImageCenter = infoImage.center
    
    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
    pinch.delegate = self
    self.infoImage.addGestureRecognizer(pinch)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
    pan.delegate = self
    self.infoImage.addGestureRecognizer(pan)
    
  }
  
  
}

