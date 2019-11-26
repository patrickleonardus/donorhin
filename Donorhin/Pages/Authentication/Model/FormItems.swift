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

enum Gender:Int {
    case female
    case male
}

struct FormBuilder {
    func getItemsForLogin(completionHandler: @escaping (([FormItems]) -> ())){
        completionHandler(
        [FormItems(img: "email", placeholder: "Email", textFieldType: .defaultTextField) ,
         FormItems(img: "password", placeholder: "Kata Sandi", textFieldType: .password)
        ])
    }
    
    func getItemsForRegister(completionHandler: @escaping (([FormItems]) -> ())){
    completionHandler(
        [FormItems(img: "email", placeholder: "Email", textFieldType: .defaultTextField) ,
         FormItems(img: "password", placeholder: "Kata Sandi", textFieldType: .password),
         FormItems(img: "re-password", placeholder: "Konfirmasi Kata Sandi", textFieldType: .password)
        ])
    }
    
    func getItemsForRegisterDetail(completionHandler: @escaping (([FormItems]) -> ())){
    completionHandler(
        [FormItems(img: "fullname-new", placeholder: "Nama Lengkap", textFieldType: .defaultTextField) ,
         FormItems(img: "gender_profile", placeholder: "Jenis Kelamin", textFieldType: .picker),
         FormItems(img: "birthday_profile", placeholder: "Tanggal Lahir", textFieldType: .datePicker),
         FormItems(img: "bloodtype_profile", placeholder: "Golongan Darah", textFieldType: .picker) ,
         FormItems(img: "lastdonor_profile", placeholder: "Donor Terakhir (Opsional)", textFieldType: .datePicker),
         FormItems(img: "codeReferral", placeholder: "Kode Referral (Opsional)", textFieldType: .defaultTextField)
        ])
    }
}
