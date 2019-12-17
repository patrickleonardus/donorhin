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
        [FormItems(img: "email_black", placeholder: "Email", textFieldType: .defaultTextField) ,
         FormItems(img: "password_black", placeholder: "Kata Sandi", textFieldType: .password)
        ])
    }
    
    func getItemsForRegister(completionHandler: @escaping (([FormItems]) -> ())){
    completionHandler(
        [FormItems(img: "email_black", placeholder: "Email", textFieldType: .defaultTextField) ,
         FormItems(img: "password_black", placeholder: "Kata Sandi", textFieldType: .password),
         FormItems(img: "repassword_black", placeholder: "Konfirmasi Kata Sandi", textFieldType: .password)
        ])
    }
    
    func getItemsForRegisterDetail(completionHandler: @escaping (([FormItems]) -> ())){
    completionHandler(
        [FormItems(img: "fullname_black", placeholder: "Nama Lengkap", textFieldType: .defaultTextField) ,
         FormItems(img: "gender_black", placeholder: "Jenis Kelamin", textFieldType: .picker),
         FormItems(img: "birthday_icon_black", placeholder: "Tanggal Lahir", textFieldType: .datePicker),
         FormItems(img: "bloodtype_black", placeholder: "Golongan Darah", textFieldType: .picker) ,
         FormItems(img: "lastdonor_black", placeholder: "Donor Terakhir (Opsional)", textFieldType: .datePicker),
         FormItems(img: "code_referral_black", placeholder: "Kode Referral (Khusus Koordinator)", textFieldType: .defaultTextField)
        ])
    }
}
