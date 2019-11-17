//
//  ModelEvent.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

struct TitleModelEvent {
    let name : String?
}

struct PlaceholderModelEvent {
    let placeholder : String?
}

struct EventData {
    
    func getEvent(completionHandler: @escaping (([TitleModelEvent]) -> ())){
        completionHandler(
            [TitleModelEvent(name: "Judul"),
            TitleModelEvent(name: "Deskripsi"),
            TitleModelEvent(name: "Tambahkan Gambar"),
            TitleModelEvent(name: "Lokasi"),
            TitleModelEvent(name: "Mulai"),
            TitleModelEvent(name: "Berakhir"),
            TitleModelEvent(name: "Nama"),
            TitleModelEvent(name: "No.HP")]
        )
    }
    
    func getPlaceholder(completionHandler: @escaping (([PlaceholderModelEvent]) -> ())){
        completionHandler(
            [PlaceholderModelEvent(placeholder: "Tambahkan judul acara"),
            PlaceholderModelEvent(placeholder: "Tambahkan deskripsi acara"),
            PlaceholderModelEvent(placeholder: "Tulis Lokasi Acara"),
            PlaceholderModelEvent(placeholder: "DD-MM-YYYY"),
            PlaceholderModelEvent(placeholder: "DD-MM-YYYY"),
            PlaceholderModelEvent(placeholder: "Nama orang yang dapat dihubungi"),
            PlaceholderModelEvent(placeholder: "No. HP yang dapat dihubungi")]
        )
    }
    
}
