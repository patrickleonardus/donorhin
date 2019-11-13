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
            [InfoItems(title: "RNI", longText: "RNI merupakan Rhesus Negatif Indonesia yang dipimpin oleh Lici Murniati. RNI berdiri dari tahun XXXX untuk mewadahi pemilik darah rhesus negatif untuk saling tolong menolong. Ibu Lici berharap dengan berdirinya RNI dapat terus mempererat ikatan sesama pemilik darah rhesus negatif. \n \nHubungi Ibu Lici (WA): +62 8XXXXXXXX \nWebsite: www.rhesusnegatif.com", videoURL: "", type: .text),
             InfoItems(title: "KHEREN", longText: "KHEREN adalah Keluarga Rhesus Negatif yang berdiri di Surabaya. KHEREN berharap dengan adanya komunitas, pemilik darah rhesus negatif bisa saling mendonorkan darah mengingat langkanya pemilik darah rhesus negatif. Atas dasar kemanusiaan, KHEREN berharap untuk terus menginspirasi masyarakat untuk donor darah yang dapat menolong hidup sesama. \n \nFacebook Page: www.facebook.com/KHEREN \nInstagram Page: www.instagram.com/KHEREN", videoURL: "", type: .text)
        ])
    }
    func getInfoWithVideo(completionHandler: @escaping (([InfoItems]) -> ())){
        completionHandler(
            [InfoItems(title: "", longText: "", videoURL: "https://www.youtube.com/watch?v=09TeUXjzpKs", type: .video),
             InfoItems(title: "Cara Penggunaan Rhelpus", longText: "Video cara penggunaan Rhelpus memperlihatkan cara untuk membuat dan menerima permintaan darah. Skip video untuk melihat cara penggunaan tertentu yang Anda inginkan:\n- Info Umum => 00:00\n- Registrasi => 02:10\n- Cari Darah => 04:30\n- Donor Darah => 08:45\n- Jelajah => 12:50", videoURL: "", type: .text),
             InfoItems(title: "Infografis Proses Alur", longText: "Proses alur untuk mencari dan mendonorkan darah rhesus negatif melalui Rhelpus dapat dilihat sebagai berikut:", videoURL: "", type: .text),
        ])
    }
    func getInfoSyaratPendonor(completionHandler: @escaping (([InfoItems]) -> ())){
        completionHandler(
            [InfoItems(title: "Syarat Pendonor", longText: "Umur 17-60 tahun\nBerat badan minimum 45 kg\nTemperatur tubuh: 36,6 - 37,5°C\nTekanan darah baik yaitu\n- sistole = 110-160 mmHg\n- diastole = 70-100 mmHg\nDenyut nadi teratur sekitar 50-100 kali/menit\nHemoglobin baik pria maupun perempuan\nminimal 12,5 g\nSetahun maksimal 5x donor dengan jarak\n penyumbang minimal 2,5 bulan", videoURL: "", type: .text),
             InfoItems(title: "Kriteria Tidak Boleh Mendonor", longText: "Wanita hamil & menyusui\nMenderita sakit jantung/paru\nMenderita kanker\nMenderita tekanan darah tinggi (hipertensi)\nMenderita kencing manis (diaberes melitus)\nKelainan darah/perdarahan abnormal\nMenderita atau ada riwayat hepatitis B/C\nKetergantungan narkoba/alkohol\nMengidap/berisiko tinggi sifilis & HIV/AIDS", videoURL: "", type: .text)
        ])
    }
    
}
