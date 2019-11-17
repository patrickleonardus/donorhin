//
//  AddEventController+UIImagePickerDelegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

extension AddEventController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            fixedImage = pickedImage.fixOrientation()
            tableView.reloadData()
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
