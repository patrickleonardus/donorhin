//
//  InfoModel.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation

struct InfoItems {
    var title : String?
    var longText : String?
    var videoURL : String?
    var type: InfoType?
}

enum InfoType {
    case video
    case text
}

struct InfoData {
    func getInfoCommunity(completionHandler: @escaping (([InfoItems]) -> ())){
        completionHandler(
            [InfoItems(title: "RNI", longText: "RNI merupakan Rhesus Negatif Indonesia yang dipimpin oleh Lici Murniati. RNI berdiri dari tahun XXXX untuk mewadahi pemilik darah rhesus negatif untuk saling tolong menolong. Ibu Lici berharap dengan berdirinya RNI dapat terus mempererat ikatan sesama pemilik darah rhesus negatif. Hubungi Ibu Lici (WA): +62 8XXXXXXXX Website: www.rhesusnegatif.com", videoURL: "", type: .text),
             InfoItems(title: "KHEREN", longText: "KHEREN adalah Keluarga Rhesus Negatif yang berdiri di Surabaya. KHEREN berharap dengan adanya komunitas, pemilik darah rhesus negatif bisa saling mendonorkan darah mengingat langkanya pemilik darah rhesus negatif. Atas dasar kemanusiaan, KHEREN berharap untuk terus menginspirasi masyarakat untuk donor darah yang dapat menolong hidup sesama. Facebook Page: www.facebook.com/KHEREN Instagram Page: www.instagram.com/KHEREN", videoURL: "", type: .text)
        ])
    }
}
