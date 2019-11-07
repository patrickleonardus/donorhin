//
//  TrackerController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 07/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class TrackerController : UIViewController {
    
    
    
    @IBOutlet weak var trackerTableView: UITableView!
    let cellId = "cellId"
    
    var stepItems : [StepItems]?
    var bloodRequest : [BloodRequest]?
    var donorAddress : String? = "PMI Tangsel"
    var donorDate : String? = "31 Nov 2019"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
        
        DummyData().getCurrentBloodRequest { (bloodRequest) in
            self.bloodRequest = bloodRequest
        }
        
        getTrackerItems { (stepItems) in
            self.stepItems = stepItems
        }
        
    }
    
    func loadTableView(){
        trackerTableView.delegate = self
        trackerTableView.dataSource = self
        trackerTableView.register(UINib(nibName: "TrackerDonorTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func getTrackerItems(completionHandler: @escaping (([StepItems]) -> ())) {
           completionHandler(
            [StepItems(id: 1, description: "Anda dapat memberitahukan PMI bahwa Anda menggunakan aplikasi untuk mencari donor", buttonStr: "Hubungi \(bloodRequest!.first!.address)"),
                StepItems(id: 2, description: "Pendonor Anda Telah Ditemukan Lokasi: \(donorAddress) Mendonor pada \(donorDate)", buttonStr: "Hubungi \(donorAddress)"),
                StepItems(id: 3, description: "Pendonor Akan Melakukan Verifikasi Kelengkapan Surat", buttonStr: ""),
                StepItems(id: 4, description: "Donor Sukses! Mohon untuk konfirmasi apabila sudah mendapatkan kantong darah", buttonStr: "Konfirmasi"),
                StepItems(id: 5, description: "Ayo Gabung Dengan Komunitas Rhesus Negatif", buttonStr: "More info")
               ]
           )
    }
        
}

