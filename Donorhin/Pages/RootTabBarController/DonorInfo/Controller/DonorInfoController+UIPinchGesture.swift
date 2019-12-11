//
//  DonorInfoController+UIPinchGesture.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 11/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension DonorInfoController : UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  @objc func pinch(sender: UIPinchGestureRecognizer){
    
    if sender.state == .began {
      let currentScale = self.infoImage.frame.size.width / self.infoImage.bounds.size.width
      let newScale = currentScale*sender.scale
      
      if newScale > 1 {
        self.isZooming = true
      }
    }
      
    else if sender.state == .changed {
      guard let view = sender.view else {return}
      let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                y: sender.location(in: view).y - view.bounds.midY)
      let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
        .scaledBy(x: sender.scale, y: sender.scale)
        .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
      let currentScale = self.infoImage.frame.size.width / self.infoImage.bounds.size.width
      var newScale = currentScale*sender.scale
      
      if newScale < 1 {
        newScale = 1
        sender.scale = 1
      }
        
      else if newScale > 5{
        newScale = 5
      }
        
      else {
        view.transform = transform
        sender.scale = 1
      }
    }
      
    else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
      
      _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
        guard let center = self.originalImageCenter else {return}
        UIView.animate(withDuration: 0.3, animations: {
          self.infoImage.transform = CGAffineTransform.identity
          self.infoImage.center = center
        }, completion: { _ in
          self.isZooming = false
        })
      }
    }
  }
  
  @objc func pan(sender: UIPanGestureRecognizer){
    
    if self.isZooming && sender.state == .changed {
      let translation = sender.translation(in: view)
      if let view = sender.view {
        view.center = CGPoint(x:view.center.x + translation.x,
                              y:view.center.y + translation.y)
      }
      sender.setTranslation(CGPoint.zero, in: self.infoImage.superview)
    }
  }
  
}
