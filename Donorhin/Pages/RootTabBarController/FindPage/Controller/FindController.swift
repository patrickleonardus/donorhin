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
        loadAllData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImageNavBar(show: false)
    }
    
    //MARK: - Mau load data dri cloudkit
    
    func loadAllData(){
        
        if userId != nil {
            loadRequestData {
                self.loadHospitalData {
                    self.loadCurrStepData {
                        
                        //reset array
                        self.bloodRequestCurrent = []
                        self.bloodRequestHistory = []
                        
                        //biar array data awal ga diintervensi sama perubahan data, maka di copy ke array lainnya
                        self.bloodRequestCurrent = self.bloodRequest
                        self.bloodRequestHistory = self.bloodRequest
                        
                        //ini mau ngereverse array, supaya nampilin data paling baru diatas
                        self.bloodRequestCurrent?.reverse()
                        self.bloodRequestHistory?.reverse()
                        
                        if self.bloodRequestHistory != nil {
                            for (index, data) in (self.bloodRequestHistory?.enumerated().reversed())! {
                                if data.status! < 5{
                                    self.bloodRequestHistory?.remove(at: index)
                                }
                            }
                        }
                        
                        if self.bloodRequestCurrent != nil{
                            for (index, data) in (self.bloodRequestCurrent?.enumerated().reversed())! {
                                if data.status! >= 5 {
                                    self.bloodRequestCurrent?.remove(at: index)
                                }
                            }
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                        }
                        
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
    
    func loadRequestData(handleComplete: @escaping (()->())){
        
        //reset array
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
                
                self.bloodRequest.append(BloodRequest(requestId: self.requestId!, hospitalId: self.hospitalId, trackerId: nil, name: self.nameTemp!, address: nil, phoneNumber: nil, date: self.dateTemp, status: nil))
                
                counter+=1
                
                if counter == requestResults.count {
                    handleComplete()
                }
            }
        }
    }
    
    func loadHospitalData(handleComplete: @escaping (()->())){
        
        var counter = 0
        
        for request in 0...bloodRequest.count-1 {
            guard let hospitalId = bloodRequest[request].hospitalId else {fatalError("hospitalId not found")}
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
    
    func loadCurrStepData(handleComplete: @escaping (()->())){
        
        var count = 0
        
        for request in 0...bloodRequest.count-1 {
            guard let requestId = bloodRequest[request].requestId else {fatalError("requestId not found")}
            let trackerPredicate = NSPredicate(format: "id_request = %@", argumentArray: [requestId])
            let trackerQuery = CKQuery(recordType: "Tracker", predicate: trackerPredicate)
            Helper.getAllData(trackerQuery) {(trackerResults) in
                guard let trackerResults = trackerResults else {fatalError("trackerResult not found")}
                for trackerResult in trackerResults {
                    let trackerModels = trackerResult.convertTrackerToTrackerModel()
                    guard let trackerModel = trackerModels else {fatalError("trackerModel not found")}
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
    
    func checkDonorAvailability(){
        
        let requestId = UserDefaults.standard.string(forKey: "requestRecordId")
        
        if requestId == nil {
            viewSearching.alpha = 0
            viewNoData.alpha = 1
        }
        else if requestId != nil {
            viewSearching.alpha = 1
            viewNoData.alpha = 0
        }
    }
    
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
    
    func checkCurrentRequestData(){
        if self.bloodRequestCurrent != nil{
            if self.bloodRequestCurrent!.count != 0 {
                DispatchQueue.main.async {
                    self.viewNoData.alpha = 0
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
    
    func checkHistoryRequestData(){
        if self.bloodRequestHistory != nil{
            if self.bloodRequestHistory!.count != 0 {
                DispatchQueue.main.async {
                    self.viewNoData.alpha = 0
                    self.viewSearching.alpha = 0
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
    
    @objc func callButton(sender: UIButton){
        let button = (sender as! CallNumberButton)
        callNumber(phoneNumber: button.phoneNumber!)
    }
    
    @objc private func profileButton(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileStoryboard") as! ProfileController
        vc.delegate = self
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        self.present(navBarOnModal, animated: true, completion: nil)
    }
    
    //MARK: Action Outlet
    
    @IBAction func findBloodSegmentedControlDidChange() {
        
        if findBloodSegmentedControl.selectedSegmentIndex == 0 {
            checkCurrentRequestData()
        }
        else if findBloodSegmentedControl.selectedSegmentIndex == 1 {
            checkHistoryRequestData()
        }
        tableView.reloadData()
    }
    
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

protocol ControlValidationViewDelegate {
    func didRequestData()
}

protocol MoveToLogin {
    func performLogin()
}
