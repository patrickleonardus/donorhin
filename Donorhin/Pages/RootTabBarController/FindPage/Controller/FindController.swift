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
  
  //MARK: IBOutlet
  @IBOutlet weak var viewNoData: UIView!
  @IBOutlet weak var viewSearching: CustomMainView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var findBloodSegmentedControl: UISegmentedControl!
  @IBOutlet weak var textSearching: UILabel!
  @IBOutlet weak var buttonSearching: CustomButtonRounded!
  
  //MARK: Variables
  let cellId = "cellId"
  
  var profileImage = UIImageView()
  
  var bloodRequestHistory: [Donor]? //Contains history finding data
  var bloodRequestCurrent: [Donor?]? //Contains current finding data
  
  
  var requestDelegate : ControlValidationViewDelegate?
  
  //declare var untuk didselect ke tracker
  var navBarTitle: String?
  var requestIdTrc: CKRecord.ID?
  var trackerIdTrc: CKRecord.ID?
  var hospitalIdTrc: CKRecord.ID?
  var currStepTrc: Int?
  
  
  //init var
  
  var bloodRequest : [Donor?] = []
  var nameTemp : String?
  var dateTemp: Date?
  var hospitalNameTemp: String?
  var hospitalNumberTemp: String?
  var requestId : CKRecord.ID?
  var hospitalId: CKRecord.ID?
  var trackerId: CKRecord.ID?
  let userId =  UserDefaults.standard.string(forKey: "currentUser")
  var currStep: Int?
  
  
  //MARK: Override View
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerForNotification()
    setupUI()
    initTableView()
    self.showSpinner(onView: self.view)
    if userId != nil {
      dataLoader { (successStatus : Bool) in
        if successStatus {
          print ("\nSuccess loading data with dataLoader!. Here are data details:")
          print ("  History:",self.bloodRequestHistory)
          print ("  Current:",self.bloodRequestCurrent)
          print ("  All: ",self.bloodRequest)
          self.checkCurrentRequestData()
          self.tableView.delegate = self
          self.tableView.dataSource = self
          self.removeSpinner()
          self.tableView.reloadData()
        }
        
      }
    }
    else {
      removeSpinner()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    profileImageNavBar(show: true)
    setupNavBarToLarge(large: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setTabBar(show: true)
    initTableView()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    profileImageNavBar(show: false)
  }
  
  //MARK:- Setting up UI
  private func setupUI(){
    viewNoData.alpha = 1
    viewSearching.alpha = 0
    textSearching.text = "Sedang Mencari Pendonor"
    buttonSearching.setTitle("Batal Mencari", for: .normal)
  }
  
  //MARK: - initializing UI
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
  
  
  //MARK: - Notification
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
  
  
  //MARK: -Data Loader
  func dataLoader(_ completionHandler: @escaping ( (Bool) -> Void )) {
    //    func dataLoader() -> Bool {
    /**
     RETURN: TRUE if the user have request data, FALSE if request of this user is nil
     */
    let group = DispatchGroup()
    var success = false
    
    print ("loading data with dataLoader...")
    self.bloodRequest = []
    self.bloodRequestHistory = []
    self.bloodRequestCurrent = []
    
    group.enter()
    self.getRequestData {requestList in
      if let requests = requestList {
//                print ("all request: \n \(requests)")
        for (n,request) in requests.enumerated() {
          print ("processing request \(request.idRequest.recordName); Need \(request.amount) bag of blood")
          
          group.enter()
          self.getTrackerDataBy(requestID: request.idRequest) { (donorList) in
            if let donorList = donorList {
              //Jika pendonor yang accept belum memenuhi
              if donorList.count < request.amount {
                self.bloodRequestCurrent! += donorList
                let margin = request.amount - donorList.count
                for _ in 1...margin {
                  self.bloodRequestCurrent?.append(nil)
                }
              }
                
              //Jika pendonor yang accept sudah memenuhi kebutuhan
              else {
                //Cek apakah semuanya udah selesai
                let isComplete = self.isEveryDonorDone(amount: request.amount, trackerOfRequest: donorList)
                
                //kalo masih ada yg belum selesai, taro semua di current
                if !isComplete {
                  self.bloodRequestCurrent! += donorList
                
                //kalo udah kelar semua taro di riwayat
                } else {
                  self.bloodRequestHistory! += donorList
                }
              }
              self.bloodRequest += donorList
            } else {
              //isi request sama tracker kosong sebanyak request.amount
              let margin = request.amount
              for _ in 1...margin {
                self.bloodRequestCurrent?.append(nil)
              }
            }
            print ("loading data tracker \(n+1)/\(requests.count)")
            group.leave()
          }
        }
        success = true
        group.leave()
      } else {
        print ("This user has no request data")
        success = false
        group.leave()
      }
    }
    group.notify(queue: DispatchQueue.main) {
      print ("out")
      completionHandler(success)
    }
  }
  
  func isEveryDonorDone(amount: Int, trackerOfRequest : [Donor]) -> Bool{
    /**
     Buat ngecek tracker of requestnya udah kelar semua apa belum
     */
    var isComplete : Int = 0
    if trackerOfRequest.count > amount {
      fatalError("Unvalid request: donor are bigger than amount needed")
    }
    
    for donor in trackerOfRequest {
      let status = donor.status ?? 0
      if status >= 5 {
        isComplete += 1
      }
    }
    return (amount == isComplete)
  }
  
  func getRequestData(_ completionHandler: @escaping ( ([RequestModel]?) -> Void)){
    /**
     Task: Fungsi ini bertugas nyari request data yang masih aktif dari user yang sedang aktif (ambil data di user default)
     Return on completion handler:  id request yang sedang berlangsung (seharusnya hanya ada 1 request yang bisa berlangsung di satu waktu)
     */
    DispatchQueue.main.async {
      self.bloodRequest = []
      var requestList : [RequestModel] = []
      
      let userIdReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.userId!), action: .none)
      let requestPredicate = NSPredicate(format: "userId = %@", argumentArray: [userIdReference])
      let requestQuery = CKQuery(recordType: "Request", predicate: requestPredicate)
      
      
      Helper.getAllData(requestQuery) { (recordss) in
        print ("user \(userIdReference.recordID.recordName); amount of record: \(String(describing: recordss?.count))")
        
        guard let records = recordss else {
          print ("empty records")
          completionHandler(nil)
          return
        }
        for record in records {
          guard let requestModel = record.convertRequestToRequestModel() else {
            fatalError("Error while converting request model")
          }
          requestList.append(requestModel)
        }
        completionHandler(requestList)
      }
    }
  }
  
  func getTrackerDataBy(requestID: CKRecord.ID, _ completionHandler: @escaping ( ([Donor]?) -> Void ) ) {
    /**
     Task: Fungsi ini bertugas nyari data tracker dari request id yang sedang aktif
     
     Possibilities:
     - BELUM ADA PENDONOR SATUPUN
     - udah ada pendonor yang nerima request tp belum semua
     - kebutuhan terpenuhi
     
     return on completion handler: tracker data sebanyak amount yang diminta
     
     */
    let group = DispatchGroup()
    
    var donorList : [Donor] = []
    let trackerPredicate = NSPredicate(format: "id_request = %@", argumentArray: [requestID])
    let trackerQuery = CKQuery(recordType: "Tracker", predicate: trackerPredicate)
    
    group.enter()
    Helper.getAllData(trackerQuery) { (donorsFound: [CKRecord]?) in
      guard let donors = donorsFound else {
        //no one accept the request
        print ("There's no one that accepted the request yet")
        completionHandler(nil)
        return
      }
      print ("request \(requestID.recordName) have amount donors:",donors.count)
      for donor in donors {
        if let tracker = donor.convertTrackerToTrackerModel() {
          //donor have filled their donor details (donor date and donor hospital)
          group.enter()
          self.getHospitalBy(hospitalID: tracker.idUTDPendonor.recordID) { (donorUTD) in
            guard let donorUTD = donorUTD else {
              fatalError("Unvalid hospital. It should have name")
            }
            donorList.append(Donor(
              requestId: requestID,
              trackerId: tracker.idTracker,
              donorHospitalID: tracker.idUTDPendonor.recordID,
              donorHospitalName: donorUTD.name,
              phoneNumber: donorUTD.phoneNumbers?[0],
              //FIXME: Nomer HP UTD bisa lebih dari 1
              donorDate: tracker.donorDate,
              status: tracker.currentStep)
            )
            print ("still working on getTrackerDataBy, UTD: ",donorUTD.name)
            group.leave()
          }
        } else if let tracker = donor.convertEmptyTrackerToEmptyTrackerModel() {
          //donor haven't filled their donor details (donor date and donor hospital)
          donorList.append(Donor(
            requestId: requestID,
            trackerId: tracker.idTracker,
            donorHospitalID: nil,
            donorHospitalName: nil,
            phoneNumber: nil,
            donorDate: nil,
            status: tracker.currentStep
          ))
        }
        
      }
      group.leave()
    }
    group.notify(queue: DispatchQueue.main) {
      if donorList.count == 0 {
        completionHandler(nil)
      } else {
        completionHandler(donorList)
      }
    }
  }
  
  func getHospitalBy( hospitalID : CKRecord.ID, _ completionHandler: @escaping ((UTDModel?) -> Void) ) {
    DispatchQueue.main.async {
      Helper.getDataByID(hospitalID) { (record) in
        guard let record = record else {
          completionHandler(nil)
          return
        }
        let utd = record.convertUTDToUTDModel()
        completionHandler(utd)
        return
      }
    }
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
  
  
  //MARK:- Make a call
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
    dfPrint.dateFormat = "dd MMM yyyy"
    
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
        patientUtdId: hospitalIdTrc!,
        step: currStepTrc!
      )
      
    }
    
  }
  
  
  
  //MARK:- Set up tab bar
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
  
  //MARK: Setup Image Nav Bar
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
    vc.findDelegate = self
    let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
    self.present(navBarOnModal, animated: true, completion: nil)
  }
  
  //MARK: Action Outlet
  
  // ini buat pencet segmented controller
  @IBAction func findBloodSegmentedControlDidChange() {
    checkCurrentRequestData()
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

protocol MoveToLoginFromFind {
  func performLogin()
}

protocol MoveToLoginFromDonate {
  func performLogin()
}

protocol MoveToLoginFromDiscover {
  func performLogin()
}
