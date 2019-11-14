//
//  FormItems.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct FormItems {
    var img : String?
    var placeholder : String?
    var textFieldType : TextFieldType?
}

enum TextFieldType {
    case password
    case picker
    case datePicker
    case defaultTextField
}

enum Gender {
    case female
    case male
}

struct FormBuilder {
    func getItemsForLogin(completionHandler: @escaping (([FormItems]) -> ())){
        completionHandler(
        [FormItems(img: "email", placeholder: "Email", textFieldType: .defaultTextField) ,
         FormItems(img: "password", placeholder: "Password", textFieldType: .password)
        ])
    }
    
    func getItemsForRegister(completionHandler: @escaping (([FormItems]) -> ())){
    completionHandler(
        [FormItems(img: "email", placeholder: "Email", textFieldType: .defaultTextField) ,
         FormItems(img: "password", placeholder: "Password", textFieldType: .password),
         FormItems(img: "re-password", placeholder: "Re-Password", textFieldType: .password)
        ])
    }
    
    func getItemsForRegisterDetail(completionHandler: @escaping (([FormItems]) -> ())){
    completionHandler(
        [FormItems(img: "", placeholder: "Fullname", textFieldType: .defaultTextField) ,
         FormItems(img: "", placeholder: "Jenis Kelamin", textFieldType: .picker),
         FormItems(img: "", placeholder: "Tanggal Lahir", textFieldType: .datePicker),
         FormItems(img: "", placeholder: "Golongan Darah", textFieldType: .picker) ,
         FormItems(img: "", placeholder: "Donor Terakhir", textFieldType: .datePicker),
         FormItems(img: "", placeholder: "Kode Referral", textFieldType: .defaultTextField)
        ])
    }
}
