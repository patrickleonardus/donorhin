//
//  FindController+ScrollView.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension FindController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let offsetPoint = scrollView.contentOffset
            
            if offsetPoint.y <= -10.0 {
                UIView.animate(withDuration: 0.2) {
                    self.findBloodSegmentedControl.alpha = 0
                }
            }
            else if offsetPoint.y >= 0.0{
                UIView.animate(withDuration: 0.3) {
                    self.findBloodSegmentedControl.alpha = 1
                }
            }
        }
    }
}

