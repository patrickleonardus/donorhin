//
//  FormQuestionModel.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 15/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct FormQuestionNameModel {
    let questionName: String?
}

struct FormQuestionPlaceholderModel {
    let placeholder: String?
}

struct FormBloodTypeModel {
    let bloodType: String?
}

struct FormQuestionData {
    
    func getFormQuestion(completionHandler: @escaping(([FormQuestionNameModel]) -> ())){
        completionHandler(
            [FormQuestionNameModel(questionName: "Nama Pasien"),
             FormQuestionNameModel(questionName: "UTD Pasien"),
             FormQuestionNameModel(questionName: "Golongan Darah"),
             FormQuestionNameModel(questionName: "Tanggal Kebutuhan"),
             FormQuestionNameModel(questionName: "Jumlah Kantung")]
        )
    }
    
    func getFormPlaceholder(completionHandler: @escaping(([FormQuestionPlaceholderModel]) -> ())){
        completionHandler(
            [FormQuestionPlaceholderModel(placeholder: "Isi nama pasien donor"),
             FormQuestionPlaceholderModel(placeholder: "Tempat asal UTD pasien"),
             FormQuestionPlaceholderModel(placeholder: "Golongan darah pasien"),
             FormQuestionPlaceholderModel(placeholder: "DD/MM/YYYY"),
             FormQuestionPlaceholderModel(placeholder: "Jumlah kantung")]
        )
    }
}

struct FormBloodType {
    func getBloodType(completionHandler: @escaping(([FormBloodTypeModel]) -> ())){
        completionHandler(
            [FormBloodTypeModel(bloodType: "O-"),
             FormBloodTypeModel(bloodType: "A-"),
             FormBloodTypeModel(bloodType: "B-"),
             FormBloodTypeModel(bloodType: "AB-")]
        )
    }
}
