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
    var donorData : [Pendonor]?
    var status : [Status]?  = []
    var navigationBarTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = Colors.backgroundView
        loadTableView()
        setNavBarTitle()
        DummyData().getCurrentBloodRequest { (bloodRequest) in
            self.bloodRequest = bloodRequest
        }
        
        PendonorDummyData().getCurrentPendonor { (donorData) in
            self.donorData = donorData
        }
        getTrackerItems { (stepItems) in
            self.stepItems = stepItems
        }
        trackerTableView.showsVerticalScrollIndicator = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setNavBarTitle(){
        navigationItem.title = navigationBarTitle
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
    
    @objc func goToMoreInfo(){
        
    }
    
    @objc func callPMIResepien(){
        callNumber(phoneNumber: "56789")
    }
    
    @objc func callPMIPendonor(){
        callNumber(phoneNumber: "12345")
    }
    
    @objc func confirmed(){
        donorData?[0].donorStatus = .confirmed
        self.getTrackerItems { (stepItems) in
            self.stepItems = stepItems
        }
        trackerTableView.reloadData()
    }
    
    func getTrackerItems(completionHandler: @escaping (([StepItems]) -> ())) {
        
        if donorData?.first?.donorStatus ==  .searching {
            status = [.onGoing, .toDo, .toDo, .toDo, .toDo]
        }
        else if donorData?.first?.donorStatus == .found {
            status = [.done, .onGoing, .toDo, .toDo, .toDo]
        }
        else if donorData?.first?.donorStatus == .verified {
            status = [.done, .done, .onGoing, .toDo, .toDo]
        }
        else if donorData?.first?.donorStatus == .done {
            status = [.done, .done, .done, .onGoing, .toDo]
        }
        else if donorData?.first?.donorStatus == .confirmed {
            status = [.done, .done, .done, .done, .done]
        }
        
           completionHandler(
            [StepItems(description: "Anda dapat memberitahukan PMI bahwa Anda menggunakan aplikasi untuk mencari donor", buttonStr: " Hubungi \(String((bloodRequest?.first?.address)!))", status: status![0]),
             StepItems(description: "Pendonor Anda Telah Ditemukan Lokasi: \(String((donorData?.first?.address)!)) Mendonor pada \(String((donorData?.first?.date!)!))", buttonStr: " Hubungi \(String((donorData?.first?.address!)!))", status: status![1]),
             StepItems(description: "Pendonor Akan Melakukan Verifikasi Kelengkapan Surat", buttonStr: "", status: status![2]),
             StepItems(description: "Donor Sukses! Mohon untuk konfirmasi apabila sudah mendapatkan kantong darah", buttonStr: " Konfirmasi", status: status![3]),
             StepItems(description: "Ayo Gabung Dengan Komunitas Rhesus Negatif", buttonStr: " More info", status: status![4])
            ]
           )
    }
        
}

