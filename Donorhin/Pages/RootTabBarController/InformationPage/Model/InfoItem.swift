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
          [InfoItems(title: "Mengenai Kontak UTD PMI", longText: "Kontak Unit Transfusi Darah Palang Merah Indonesia (UTD PMI) dibutuhkan agar resipien dan pendonor rhesus negatif dapat saling berkoordinasi melalui UTD PMI masing-masing. Hal ini dilakukan untuk meminimalisasi praktik calo darah jika terjadi interaksi antara resipien dan pendonor secara langsung. Tim Donorhin berharap bahwa pendonor darah rhesus negatif melakukan dengan sukarela dengan alasan kemanusiaan. Begitu pun dengan resipien, Tim Donorhin berharap resipien kelak dapat menjadi pendonor dan menolong sesama.", videoURL: "", type: .text),
             InfoItems(title: "Sumber Akses UTD PMI", longText: "Kontak UTD PMI didapatkan melalui website http://ayodonor.pmi.or.id/table.php yang disimpan dalam database Donorhin. Jika terdapat pembaruan UTD PMI dalam hal telepon, alamat, koordinat, dll. dapat menghubungi Tim Donorhin. Kami juga masih mengumpulkan kontak-kontak UTD PMI di seluruh Indonesia yang mungkin belum terdaftar. Jika ingin menaruh UTD PMI dalam aplikasi Donorhin dapat menghubungi kami lewat direct message di Instagram @donorhin.id. Kami sungguh berterimakasih atas kerjasama Bapak/Ibu/Sdr. yang telah membantu kami.", videoURL: "", type: .text)
        ])
    }
    func getInfoWithVideo(completionHandler: @escaping (([InfoItems]) -> ())){
        completionHandler(
            [InfoItems(title: "", longText: "", videoURL: "https://www.youtube.com/watch?v=EZLRaD1-AaI", type: .video),
             InfoItems(title: "Video Penggunaan Donorhin", longText: "Video cara penggunaan Donorhin memperlihatkan cara untuk membuat dan menerima permintaan darah. Skip video untuk melihat cara penggunaan tertentu yang Anda inginkan:\n- Info Umum => 00:00\n- Registrasi => 02:10\n- Cari Darah => 04:30\n- Donor Darah => 08:45\n- Jelajah => 12:50", videoURL: "", type: .text),
             InfoItems(title: "Infografis Alur Proses", longText: "Proses alur untuk mencari dan mendonorkan darah rhesus negatif melalui Donorhin dapat dilihat sebagai berikut:", videoURL: "", type: .text),
        ])
    }
    func getInfoSyaratPendonor(completionHandler: @escaping (([InfoItems]) -> ())){
        completionHandler(
            [InfoItems(title: "Syarat Pendonor", longText: "• Umur 17-60 tahun\n• Berat badan minimum 45 kg\n•Temperatur tubuh: 36,6 - 37,5°C\n• Tekanan darah baik yaitu\n- sistole = 110-160 mmHg\n- diastole = 70-100 mmHg\n• Denyut nadi teratur sekitar 50-100 kali/menit\n• Hemoglobin baik pria maupun perempuan\n• minimal 12,5 g\n• Setahun maksimal 5x donor dengan jarak\n penyumbang minimal 2,5 bulan", videoURL: "", type: .text),
             InfoItems(title: "Kriteria Tidak Boleh Mendonor", longText: "• Wanita hamil & menyusui\n• Menderita sakit jantung/paru\n• Menderita kanker\n• Menderita tekanan darah tinggi (hipertensi)\n• Menderita kencing manis (diaberes melitus)\n• Kelainan darah/perdarahan abnormal\n• Menderita atau ada riwayat hepatitis B/C\n• Ketergantungan narkoba/alkohol\n• Mengidap/berisiko tinggi sifilis & HIV/AIDS", videoURL: "", type: .text)
        ])
    }
  func getInfoUTD(completionHandler: @escaping (([InfoItems]) -> ())){
    completionHandler(
      [InfoItems(title: "BPPD", longText: "Pengelolaan darah membutuhkan biaya untuk ketersediaan formulir calon donor, kapas, alat untuk mengecek Hb donor, jarum, selang dan kantong yang digunakan untuk proses donor dan menyimpan darah. Berbagai komponen yang diperlukan untuk memeriksa darah dilaboratorium, menyimpan darah di tempat khusus, termasuk bagaimana prosedur pemusnahan darah yang tidak layak digunakan, juga membutuhkan biaya operasional. Biaya ini berasal dari subsidi pemerintah maupun subsidi PMI. Sisa beban biaya inilah yang tidak tersubsidi yang dinamakan Biaya Penggantian Pengelolaan Darah (BPPD) atau service cost yang dibebankan kepada pasian bukan komponen darahnya itu sendiri.\n(Source: pmi.or.id)", videoURL: "", type: .text),
       InfoItems(title: "Rhesus", longText: "Rhesus atau faktor rhesus adalah kadar protein khusus (Antigen D) pada permukaan sel darah merah. Tidak semua orang memiliki protein pada permukaan sel darah merahnya. Seseorang yang sel darah merahnya terdapat protein tersebut berarti dinyatakan memiliki rhesus positif (biasa ditulis Rh+). Jika seseorang tidak memiliki protein tersebut pada sel darah merahnya, berarti dinyatakan memiliki rhesus negatif (atau Rh-). \n(Source: alodokter.com)", videoURL: "", type: .text)]
    )
  }
  
  func getInfoKoordinator(completion: @escaping (([InfoItems]) -> ())){
    completion(
        [InfoItems(title: "Koordinator di Donorhin", longText: "Saat Anda registrasi, Anda mempunyai opsi untuk menulis kode koordinator. Kode koordinator merupakan kode yang hanya dimiliki oleh koordinator wilayah dari komunitas rhesus negatif di Indonesia. Kode ini diberikan agar para koordinator dapat mem-posting acara baru di halaman jelajah. Jadi, setiap acara yang ada di halaman jelajah dapat dipertanggung jawabkan karena hanya dapat di-posting oleh koordinator. Jika Anda ingin menampilkan acara yang berhubungan dengan rhesus negatif namun tidak mempunyai kode koordinator, Anda dapat menghubungi Tim Donorhin dengan direct message di Instagram @donorhin.id.", videoURL: "", type: .text)]
    )
  }
}
