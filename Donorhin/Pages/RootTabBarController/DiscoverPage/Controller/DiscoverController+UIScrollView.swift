//
//  DiscoverController+UIScrollView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension DiscoverController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let navBarHeight = Double((navigationController?.navigationBar.frame.height)!)
        
        if navBarHeight < 90.0 {
            UIView.animate(withDuration: 0.2) {
                self.profileImage.alpha = 0.0
            }
            
        }
        else if navBarHeight >= 90.0 {
            UIView.animate(withDuration: 0.2) {
                self.profileImage.alpha = 1.0
            }
        }
    }
    
}
