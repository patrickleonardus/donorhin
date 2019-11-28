//
//  FindController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

class FindController: UIViewController {
    
    
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewSearching: CustomMainView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findBloodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var textSearching: UILabel!
    @IBOutlet weak var buttonSearching: CustomButtonRounded!
    
    let cellId = "cellId"
    
    var profileImage = UIImageView()
    
    var bloodRequestHistory: [BloodRequest]?
    var bloodRequestCurrent: [BloodRequest]?
    
    var requestDelegate : ControlValidationViewDelegate?
    
    //declare var untuk didselect ke tracker
    var navBarTitle: String?
    var requestIdTrc: CKRecord.ID?
    var trackerIdTrc: CKRecord.ID?
    var hospitalIdTrc: CKRecord.ID?
    var currStepTrc: Int?
    
    
    //init var
    
    var bloodRequest : [BloodRequest] = []
    var nameTemp : String?
    var dateTemp: Date?
    var hospitalNameTemp: String?
    var hospitalNumberTemp: String?
    var requestId : CKRecord.ID?
    var hospitalId: CKRecord.ID?
    var trackerId: CKRecord.ID?
    let userId =  UserDefaults.standard.string(forKey: "currentUser")
    var currStep: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.registerForNotification()
        setupUI()
        initTableView()
        
    }
  
  private func registerForNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) {[weak self] (granted, err) in
      guard granted else {return}
      self?.getNotificationSettings()
    }
  }
  
  private func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      guard settings.authorizationStatus == .authorized else {return}
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
    override func viewDidAppear(_ animated: Bool) {
        profileImageNavBar(show: true)
        setupNavBarToLarge(large: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBar(show: true)
        initTableView()
        loadAllData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImageNavBar(show: false)
    }
    
    //MARK: - Mau load data dri cloudkit
    
    // nah ini function yg dipake buat ngeload sama satuin semua data yg diquery satu satu di function yg paling bawah
    func loadAllData(){
        
        if userId != nil {
            // ini kaya begini biar kalo request data udh kelar baru dia jalanin yg load data.
            loadRequestData {
                self.loadHospitalData {
                    // ini juga sama, kalo dia udh kelar query ke hospital data, baru dia query ke curr step data
                    self.loadCurrStepData {
                        
                        //reset array - direset jadi setiap di load datanya ga double double
                        self.bloodRequestCurrent = []
                        self.bloodRequestHistory = []
                        
                        //biar array data awal ga diintervensi sama perubahan data, maka di copy ke array lainnya
                        
                        // jadi array awalnya itu adalah bloodRequest
                        // bloodRequest ini nampung seluruh data dari hasil query yg di dpt
                        // cuma karena mau tampilin data di tab "sedang berlangsung" gw bikin array lagi namanya "bloodRequestCurrent"
                        // sama kaya diatas, karena mau tampilin data "riwayat" gw bikin lagi array namanya "bloodRequestHistory"
                        
                        
                        // trus gw copy dri bloodRequest ke array yg udh dibuat sebelomnya
                        self.bloodRequestCurrent = self.bloodRequest
                        self.bloodRequestHistory = self.bloodRequest
                        
                        //ini mau ngereverse array, supaya nampilin data paling baru diatas
                        self.bloodRequestCurrent?.reverse()
                        self.bloodRequestHistory?.reverse()
                        
                        // nah karena di tabel riwayat mau tampilin data yg udh kelar donor, maka gw hapus element didalem array yg statusnya dibawah 5
                        // klo statusnya 5 itu = "Pendonor telah selesai mendonor"
                        if self.bloodRequestHistory != nil {
                            for (index, data) in (self.bloodRequestHistory?.enumerated().reversed())! {
                                if data.status! < 5{
                                    self.bloodRequestHistory?.remove(at: index)
                                }
                            }
                        }
                        
                        // ini buat hapus element yg udh kelar donor, karena data yg di array ini mau ditampilin di tab "sedang berlangsung", maka gw hapus semua data yg statusnya diatas 5, yang berarti emg proses donornya belom kelar
                        if self.bloodRequestCurrent != nil{
                            for (index, data) in (self.bloodRequestCurrent?.enumerated().reversed())! {
                                if data.status! >= 5 {
                                    self.bloodRequestCurrent?.remove(at: index)
                                }
                            }
                        }
                        
                        // nah ini buat supaya table viewnya ga error, jadi klo datanya udh siap baru table datanya di load
                        // jadi klo semua perintah diatas ini udh dilakuin, maka baru di declare delegate sama data sourcenya trus di reload datanya, begitu kawan kawan
                        DispatchQueue.main.async {
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                        }
                        // ini buat ngecek tampilan sedang berlangsung, klo ada data dia buang tombol donor, klo ga ada data dia tampilin tombol donor
                        // intinya ini buat ngilangin tombol "Cari Donor" klo datanya udh ada
                        self.checkCurrentRequestData()
                    }
                }
            }
        }
        else if userId == nil {
            bloodRequestHistory = []
            bloodRequestCurrent = []
        }
    }
    
    // nah ini buat ngeload data dari table request berdasarkan user id yg login apps
    func loadRequestData(handleComplete: @escaping (()->())){
        
        //reset array - supaya kalo nge load ulang, data yg lama di hapus
        bloodRequest = []
        
        let userIdReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: userId!), action: .none)
        let requestPredicate = NSPredicate(format: "userId = %@", argumentArray: [userIdReference])
        let requestQuery = CKQuery(recordType: "Request", predicate: requestPredicate)
        
        Helper.getAllData(requestQuery) { (requestResults) in
            
            guard let requestResults = requestResults else {fatalError("Query in Request Error")}
            
            if requestResults.count != 0 {
                DispatchQueue.main.async {
                    self.showSpinner(onView: self.view)
                }
            }
            
            var counter = 0
            for requestResult in requestResults {
                let requestModels = requestResult.convertRequestToRequestModel()
                guard let requestModel = requestModels else {fatalError("Error when convert request to model")}
                self.nameTemp = requestModel.patientName
                self.dateTemp = requestModel.dateNeed
                self.requestId = requestModel.idRequest
                self.hospitalId = requestModel.idUTDPatient
                
                // ini nge append ke arraynya, karena ada beberapa array yg harus di query sendiri sendiri di table lain, maka ada beberapa element yg dikasih nil
                // nilai element yg di nil kan, akan di update di query selanjutnya
                self.bloodRequest.append(BloodRequest(requestId: self.requestId!, hospitalId: self.hospitalId, trackerId: nil, name: self.nameTemp!, address: nil, phoneNumber: nil, date: self.dateTemp, status: nil))
                
                counter+=1
                
                if counter == requestResults.count {
                    handleComplete()
                }
            }
        }
    }
    
    // ini buat ngequery ambil data utd kaya nama utdnya sama nomor telpon utdnya
    func loadHospitalData(handleComplete: @escaping (()->())){
        
        var counter = 0
        
        //ini mau nge assign nama utd dan nomor telepon ke array yg udh ada sebelumnya
        //ini buat neglooping sebanyak data di array
        for request in 0...bloodRequest.count-1 {
            // ini mau nge assign hospital id berdasarkan index loopingannya
            guard let hospitalId = bloodRequest[request].hospitalId else {fatalError("hospitalId not found")}
            
            //get data utd
            let record = CKRecord(recordType: "UTD", recordID: hospitalId)
            Helper.getDataByID(record){ (utdResults) in
                guard let utdResults = utdResults else {fatalError("utdResults not found")}
                let utdModels = utdResults.convertUTDToUTDModel()
                guard let utdModel = utdModels else {fatalError("utdModel not found")}
                self.hospitalNameTemp = utdModel.name
                self.hospitalNumberTemp = utdModel.phoneNumbers![0]
                
                self.bloodRequest[request].address = self.hospitalNameTemp
                self.bloodRequest[request].phoneNumber = self.hospitalNumberTemp
                
                counter+=1
                if counter == self.bloodRequest.count {
                    handleComplete()
                }
            }
        }
    }
    
    // ini asalnya buat ngequery ambil statusnya
    func loadCurrStepData(handleComplete: @escaping (()->())){
        
        var count = 0
        // buat ambil data currrent stepnya
        for request in 0...bloodRequest.count-1 {
            guard let requestId = bloodRequest[request].requestId else {fatalError("requestId not found")}
            let trackerPredicate = NSPredicate(format: "id_request = %@", argumentArray: [requestId])
            let trackerQuery = CKQuery(recordType: "Tracker", predicate: trackerPredicate)
            Helper.getAllData(trackerQuery) {(trackerResults) in
                guard let trackerResults = trackerResults else {fatalError("trackerResult not found")}
                for trackerResult in trackerResults {
                    if let trackerModels = trackerResult.convertTrackerToTrackerModel() {
                        let trackerModel = trackerModels
                        self.currStep = trackerModel.currentStep
                        self.trackerId = trackerModel.idTracker
                        self.bloodRequest[request].status = self.currStep
                        self.bloodRequest[request].trackerId = self.trackerId
                        
                        count+=1
                        if count == self.bloodRequest.count {
                            self.removeSpinner()
                            handleComplete()
                        }

                    }
                    else if let emptyTrackerModels = trackerResult.convertEmptyTrackerToEmptyTrackerModel() {
                        let trackerModel = emptyTrackerModels
                        self.currStep = trackerModel.currentStep
                        self.trackerId = trackerModel.idTracker
                        self.bloodRequest[request].status = self.currStep
                        self.bloodRequest[request].trackerId = self.trackerId
                        
                        count+=1
                        if count == self.bloodRequest.count {
                            self.removeSpinner()
                            handleComplete()
                        }
                    }
                    
                }
//                if trackerResults.count == 0 {
//                    self.removeSpinner()
//                    DispatchQueue.main.async {
//                        self.viewSearching.alpha = 1
//                        self.viewNoData.alpha = 0
//                    }
//                }
            }
        }
    }
    
    
    
    //MARK: - initialize variable
    private func initTableView(){
        tableView.register(UINib(nibName: "FindBloodCustomCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavBarToLarge(large: Bool){
        if large {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        else {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    private func setupUI(){
        viewNoData.alpha = 1
        viewSearching.alpha = 0
        textSearching.text = "Sedang Mencari Pendonor"
        buttonSearching.setTitle("Batal Mencari", for: .normal)
    }
    
//    func checkDonorAvailability(){
//        
//        let requestId = UserDefaults.standard.string(forKey: "requestRecordId")
//        
//        if requestId == nil {
//            viewSearching.alpha = 0
//            viewNoData.alpha = 1
//        }
//        else if requestId != nil {
//            viewSearching.alpha = 1
//            viewNoData.alpha = 0
//        }
//    }
    
    // ini buat hilangin tab bar klo di push
    private func setTabBar(show: Bool){
        if show {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 1
            }
        }
        else {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.tabBar.alpha = 0
            }
        }
    }
    // func buat nelpon
    private func callNumber(phoneNumber: String){
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // ini untuk buat tanggal di tableview jadi ringkes
    func shrinkDate(_ date: Date) -> String{
        
        let dfPrint = DateFormatter()
        dfPrint.dateFormat = "dd MMMM yyyy"
        
        return dfPrint.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToForm" {
            
            guard let navigationController = segue.destination as? UINavigationController else {return}
            guard let formController = navigationController.viewControllers.first as? FormController else {return}
            
            formController.viewValidationDelegate = sender as? ControlValidationViewDelegate
            
        }
            // ini segue yang buat pindah ke tracker
        else if segue.identifier == "moveToTracker" {
            
            let destination = segue.destination as! TrackerController
            destination.navigationBarTitle =  navBarTitle
            destination.input = SearchTrackerInput(
                idRequest: requestIdTrc!,
                idTracker: trackerIdTrc!,
                patientUtdId: hospitalId!,
                step: currStepTrc!
            )
            
        }
        
    }
    
    func profileImageNavBar(show: Bool){
        
        let navBarHeight = Double((navigationController?.navigationBar.frame.height)!)
        
        if show {
            if navBarHeight >= 90.0 {
                profileImage = UIImageView(image: UIImage(named: "user_profile_default"))
                navigationController?.navigationBar.addSubview(profileImage)
                profileImage.isUserInteractionEnabled = true
                profileImage.layer.cornerRadius = ProfileImageSize.imageSize/2
                profileImage.clipsToBounds = true
                
                profileImage.translatesAutoresizingMaskIntoConstraints = false
                profileImage.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -ProfileImageSize.marginRight).isActive = true
                profileImage.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -ProfileImageSize.marginBottom).isActive = true
                profileImage.heightAnchor.constraint(equalToConstant: ProfileImageSize.imageSize).isActive = true
                profileImage.widthAnchor.constraint(equalToConstant: ProfileImageSize.imageSize).isActive = true
                
                let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileButton))
                profileImage.addGestureRecognizer(profileTap)
                
                UIView.animate(withDuration: 1.0) {
                    self.profileImage.alpha = 1.0
                }
            }
        }
            
        else {
            UIView.animate(withDuration: 0.1) {
                self.profileImage.alpha = 0.0
                
            }
        }
    }
    
    // ini buat ngecek tampilan sedang berlangsung, klo ada data dia buang tombol donor, klo ga ada data dia tampilin tombol donor
    func checkCurrentRequestData(){
        if self.bloodRequestCurrent != nil{
            if self.bloodRequestCurrent!.count != 0 {
                DispatchQueue.main.async {
                    self.viewNoData.alpha = 0
                }
                
            }
            else if self.bloodRequestCurrent?.count == 0 {
                DispatchQueue.main.async {
                    self.viewNoData.alpha = 1
                }
            }
        }
        else if self.bloodRequestCurrent == nil{
            DispatchQueue.main.async {
                self.viewNoData.alpha = 1
            }
        }
    }
    
    // ini buat cek tampilan riwayat
    func checkHistoryRequestData(){
        if self.bloodRequestHistory != nil{
            if self.bloodRequestHistory!.count != 0 {
                DispatchQueue.main.async {
                    self.viewNoData.alpha = 0
                    self.viewSearching.alpha = 0
                }
                
            }
            else if self.bloodRequestHistory?.count == 0 {
                DispatchQueue.main.async {
                    self.viewNoData.alpha = 1
                }
            }
        }
        else if self.bloodRequestHistory == nil{
            DispatchQueue.main.async {
                self.viewNoData.alpha = 1
            }
        }
    }
    
    //MARK: Action
    
    // ini mau call pmi pendonor
    @objc func callButton(sender: UIButton){
        let button = (sender as! CallNumberButton)
        callNumber(phoneNumber: button.phoneNumber!)
    }
    // ini buat pencet button profile
    @objc private func profileButton(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileStoryboard") as! ProfileController
        vc.delegate = self
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        self.present(navBarOnModal, animated: true, completion: nil)
    }
    
    //MARK: Action Outlet
    
    // ini buat pencet segmented controller
    @IBAction func findBloodSegmentedControlDidChange() {
        
        if findBloodSegmentedControl.selectedSegmentIndex == 0 {
            checkCurrentRequestData()
        }
        else if findBloodSegmentedControl.selectedSegmentIndex == 1 {
            checkHistoryRequestData()
        }
        tableView.reloadData()
    }
    
    // ini buat tombol "Cari Darah"
    @IBAction func findBloodAction(_ sender: Any) {
        
        let checkLogin = UserDefaults.standard.string(forKey: "currentUser")
        
        if checkLogin != nil {
            performSegue(withIdentifier: "moveToForm", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Anda belum login", message: "SIlahkan login terlebih dahulu untuk melakukan pencarian darah.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Nanti saja", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Login sekarang", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "MoveToLogin", sender: self)
            }))
            self.present(alert,animated: true)
        }
        
    }
    
}
//ini protocol ga jadi pake
protocol ControlValidationViewDelegate {
    func didRequestData()
}

protocol MoveToLogin {
    func performLogin()
}
