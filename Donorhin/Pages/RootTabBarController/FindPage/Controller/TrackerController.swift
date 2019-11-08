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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func loadTableView(){
        trackerTableView.delegate = self
        trackerTableView.dataSource = self
        trackerTableView.register(UINib(nibName: "TrackerDonorTableViewCell", bundle: nil), forCellReuseIdentifier: "trackerCell")
        trackerTableView.tableFooterView = UIView()
        trackerTableView.reloadData()
    }
    
    private func callNumber(phoneNumber: String){
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
    @objc func callButton(){
           callNumber(phoneNumber: "081317019898")
    }
    
    func getTrackerItems(completionHandler: @escaping (([StepItems]) -> ())) {
           completionHandler(
            [StepItems(description: "Anda dapat memberitahukan PMI bahwa Anda menggunakan aplikasi untuk mencari donor", buttonStr: " Hubungi \(String((bloodRequest?.first?.address)!))", status: .done),
             StepItems(description: "Pendonor Anda Telah Ditemukan Lokasi: \(String(donorAddress!)) Mendonor pada \(String(donorDate!))", buttonStr: " Hubungi \(String(donorAddress!))", status: .onGoing),
             StepItems(description: "Pendonor Akan Melakukan Verifikasi Kelengkapan Surat", buttonStr: "", status: .toDo),
             StepItems(description: "Donor Sukses! Mohon untuk konfirmasi apabila sudah mendapatkan kantong darah", buttonStr: " Konfirmasi", status: .toDo),
             StepItems(description: "Ayo Gabung Dengan Komunitas Rhesus Negatif", buttonStr: " More info", status: .toDo)
            ]
           )
    }
        
}

