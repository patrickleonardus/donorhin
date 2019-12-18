//
//  DonateController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit
class DonateController: UIViewController {
  //MARK:-  IBOutlets
  @IBOutlet weak var switchButtonStatusDonor: UISwitch!
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var coverView: CustomMainView!
  @IBOutlet weak var imageCoverView: UIImageView!
  @IBOutlet weak var labelCoverView: UILabel!
  @IBOutlet weak var buttonCoverView: CustomButtonRounded!
  
  
  //MARK: - Variables
  final private let cellReuseIdentifier = "DonateCell"
  var listRequestCurrent = [CKRecord]()
  var listRequestHistory = [CKRecord]()
  var selectedData: TrackerModel?
  var statusDonor = false
  
  var tableViewTitle = ["Sedang Berlangsung","Riwayat Mendonor"]
  
  var profileImage = UIImageView()
  var confirmButton = UIBarButtonItem()
  var currentUser : String?
  
  var notificationIdentifier: String?
   
  //MARK:- view handler
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentUser = UserDefaults.standard.string(forKey: "currentUser")
    if let _ = self.selectedData {
      performSegue(withIdentifier: "GoToStep", sender: nil)
    }
    
    configureRefreshControl()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tableview.delegate = self
    self.tableview.dataSource = self
    self.tableview.register(UINib(nibName: "DonateTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
    self.checkStatusDonor()
    checkData()
    
  }
   
   override func viewDidAppear(_ animated: Bool) {
      profileImageNavBar(show: true)
      setupTabledView()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      profileImageNavBar(show: false)
      self.removeSpinner()
   }
  
  func configureRefreshControl () {
    // Add the refresh control to your UIScrollView object.
    tableview.refreshControl = UIRefreshControl()
    tableview.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
  }
  
  @objc func handleRefreshControl() {
    // Update your content…
    getCurrentData()
    getHistoryData()
    self.removeSpinner()
    self.removeSpinner()
  }
  
  //Check udh login apa belom
  private func checkData(){
    if currentUser == nil {
      imageCoverView.image = UIImage(named: "permintaanKososngGambar")
      labelCoverView.text = "Anda harus login untuk mengetahui jika terdapat permintaan darah"
      buttonCoverView.setTitle("Login Sekarang", for: .normal)
      buttonCoverView.addTarget(self, action: #selector(moveToLogin), for: .touchUpInside)
    }
    else if currentUser != nil {
      buttonCoverView.isHidden = true
      imageCoverView.image = UIImage(named: "permintaanKososngGambar")
      labelCoverView.text = "Belum ada permintaan darah"
    }
  }
  
  //Biar masuk ke login
  @objc private func moveToLogin(){
    self.performSegue(withIdentifier: "moveToLoginFromDonate", sender: self)
  }
  
  
   //MARK: - data if 0 image will show up
   private func checkCountListData() {
      if self.listRequestCurrent.count > 0 || self.listRequestHistory.count > 0{
         self.coverView.isHidden = true
      }
      else {
         self.coverView.isHidden = false
      }
   }
   
  //MARK:- Get data from database
  private func getHistoryData() {
    self.showSpinner(onView: self.view)
    if currentUser != nil {
      
      let historyPredicate = NSPredicate(format: "id_pendonor == %@ AND current_step == 6",CKRecord.ID(recordName: self.currentUser!))
      
      let historyQuery = CKQuery(recordType: "Tracker", predicate: historyPredicate)
      Helper.getAllData(historyQuery) { (results) in
        if let results = results {
          DispatchQueue.main.async {
            self.listRequestHistory = results
            self.checkCountListData()
            self.removeSpinner()
            self.tableview.reloadData()
            self.tableview.refreshControl?.endRefreshing()
          }
        }
        else {
          self.removeSpinner()
          self.tableview.refreshControl?.endRefreshing()
        }
      }
    }
    else if currentUser == nil {
      self.removeSpinner()
      self.tableview.refreshControl?.endRefreshing()
      print("User hasn't Login")
    }
  }
  
  private func getCurrentData(){
    self.showSpinner(onView: self.view)
    if currentUser != nil {
      
      let currentPredicate = NSPredicate(format: "id_pendonor == %@ AND current_step <= \(StepsEnum.done_5)", CKRecord.ID(recordName: self.currentUser!))
      
      let currentQuery = CKQuery(recordType: "Tracker", predicate: currentPredicate)
      Helper.getAllData(currentQuery) { (results) in
        if let results = results {
          DispatchQueue.main.async {
            self.listRequestCurrent = results
            self.checkCountListData()
            self.removeSpinner()
            self.tableview.reloadData()
            self.tableview.refreshControl?.endRefreshing()
          }
        }
        else {
          self.removeSpinner()
          self.tableview.refreshControl?.endRefreshing()
        }
      }
    }
      
    else if currentUser == nil {
      self.removeSpinner()
      self.tableview.refreshControl?.endRefreshing()
      print("User hasn't Login")
    }
  }
   
   private func checkStatusDonor() {
      if !self.statusDonor {
         self.switchButtonStatusDonor.isEnabled = false
      }
   }
   
   //MARK: - setup tableview
  private func setupTabledView() {
    
    getCurrentData()
    getHistoryData()
    
    tableview.backgroundColor = UIColor.clear
    tableview.tableFooterView = UIView()
   }
  
   private func profileImageNavBar(show: Bool){
      
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
   
   //MARK: -Action Function
   @objc private func profileButton(){
      let storyboard = UIStoryboard(name: "Profile", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "profileStoryboard") as! ProfileController
    vc.donateDelegate = self
      let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
      self.present(navBarOnModal, animated: true, completion: nil)
   }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToStep" {
      let stepVC = segue.destination as! DonateStepsViewController
      
      stepVC.request = self.selectedData
      
      stepVC.title = "Permintaan Darah 1"
    }
    
    else if segue.identifier == "moveToLoginFromDonate"{
        if let navigationController = segue.destination as? UINavigationController {
            let childViewController = navigationController.topViewController as? LoginController
            childViewController?.rootViewController = self
        }
    }
  }
   
}

//MARK:- Table View handler

extension DonateController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var height : CGFloat = 0
    
    if indexPath.section == 0 {
      height = 90
    }
    else {
      height = 90
    }
    
    return height
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var numberOfSection = 0
    
    if section == 0 {
      if listRequestCurrent.count == 0 {
        numberOfSection = 1
      }
      else if listRequestCurrent.count > 0 {
        numberOfSection = listRequestCurrent.count
      }
    }
    else {
      if listRequestHistory.count == 0 {
        numberOfSection = 1
      }
      else if listRequestHistory.count > 0 {
        numberOfSection = listRequestHistory.count
      }
    }
    
    return numberOfSection
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 42
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height))
    headerView.backgroundColor = Colors.backgroundView
    
    let label : UILabel = UILabel(frame: CGRect(x: 12, y: 8, width: tableView.frame.size.width, height: 30))
    label.text = tableViewTitle[section]
    label.font = UIFont.boldSystemFont(ofSize: 20)
    
    headerView.addSubview(label)
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! DonateTableViewCell
    
    let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
    
    if (indexPath.row == lastRowIndex - 1) {
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
    }
    
    if indexPath.section == 0 {
      
      if listRequestCurrent.count == 0 {
        cell.personImage.image = UIImage(named: "no_data")
        cell.titleLabel.text = "Belum Ada Permintaan Darah"
        cell.subtitleLabel.text = ""
      }
        
      else {
        
        let data = listRequestCurrent[indexPath.row]
        
        let steps = Steps.checkStepForDonor(data["current_step"]!)
        
        cell.personImage.image = UIImage(named: "person_50")
        cell.titleLabel.text = "Permintaan Darah"
        cell.subtitleLabel.text = steps
        cell.topConstraints.isActive = false
      }
    }
    
    else {
     
      if listRequestHistory.count == 0 {
        cell.personImage.image = UIImage(named: "no_data")
        cell.titleLabel.text = "Belum Ada Permintaan Darah"
        cell.subtitleLabel.text = ""
      }
        
      else {
        
        let data = listRequestHistory[indexPath.row]
        
        let rawDate = "\(String(describing: data["donor_date"]!))"
        
        let rawDateFormatter = DateFormatter()
        let showDateFormatter = DateFormatter()
        rawDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
        showDateFormatter.dateFormat = "dd MMMM yyyy"
        let date = rawDateFormatter.date(from: rawDate)
        let showDate = showDateFormatter.string(from: date!)
        
        
        cell.personImage.image = UIImage(named: "person_50")
        cell.titleLabel.text = "Permintaan Darah ke \(indexPath.row + 1)"
        cell.subtitleLabel.text = "Selesai - \(showDate)"
        cell.topConstraints.isActive = false
        
      }
    }
    
    cell.layer.backgroundColor = UIColor.white.cgColor
    cell.layer.cornerRadius = 14
    
    cell.layer.borderWidth = 5
    cell.layer.borderColor = Colors.backgroundView.cgColor
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableview.deselectRow(at: indexPath, animated: true)
    
    
    if indexPath.section == 0 {
     
      if listRequestCurrent.count == 0 {
        print("No Data")
      }
      else if listRequestCurrent.count > 0 {
        self.selectedData = self.listRequestCurrent[indexPath.row].convertTrackerToTrackerModel()
        performSegue(withIdentifier: "GoToStep", sender: tableView.cellForRow(at: indexPath))
      }
    }
    else {
      
      if listRequestHistory.count == 0 {
        print("No Data")
      }
      else if listRequestHistory.count > 0 {
        self.selectedData = self.listRequestHistory[indexPath.row].convertTrackerToTrackerModel()
        performSegue(withIdentifier: "GoToStep", sender: tableView.cellForRow(at: indexPath))
      }
    }
  }
}

//extension DonateController: UITableViewDelegate, UITableViewDataSource {
//   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      return self.listRequest.count
//   }
//
//   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      let cell = tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! DonateTableViewCell
//      cell.personImage.image = UIImage(named: "person_50")
//      cell.titleLabel.text = "Permintaan donor \(indexPath.row+1)"
//      cell.subtitleLabel.text = Steps.checkStep(
//         self.listRequest[indexPath.row].value(
//            forKey: "current_step") as! Int)
//      return cell
//   }
//
//   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//      if editingStyle == .delete {
//         print("ok")
//      }
//   }
//
//   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//      let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
//         self.tableview.dataSource?.tableView?(self.tableview, commit: .delete, forRowAt: indexPath)
//      })
//      deleteButton.backgroundColor = Colors.red
//      return [deleteButton]
//   }
//
//   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      self.selectedData = self.listRequest[indexPath.row].convertTrackerToTrackerModel()
//      self.tableview.cellForRow(at: indexPath)?.isSelected = false
//      performSegue(withIdentifier: "GoToStep", sender: tableView.cellForRow(at: indexPath))
//   }
//
//}
