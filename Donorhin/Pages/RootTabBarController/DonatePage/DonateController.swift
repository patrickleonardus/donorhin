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
  @IBOutlet weak var historyDonorSegmentedControl: UISegmentedControl!
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var coverView: CustomMainView!
  @IBOutlet weak var imageCoverView: UIImageView!
  @IBOutlet weak var labelCoverView: UILabel!
  @IBOutlet weak var buttonCoverView: CustomButtonRounded!
  
  
  //MARK: - Variables
  final private let cellReuseIdentifier = "DonateCell"
  var listRequest = [CKRecord]()
  var selectedData: TrackerModel?
  var statusDonor = false
  var segmented: History {
    if historyDonorSegmentedControl.selectedSegmentIndex == 0 {
       return .active
    } else {
       return .history
    }
  }
  var profileImage = UIImageView()
  var confirmButton = UIBarButtonItem()
  var currentUser : String?
  
  var notificationIdentifier: String?
   
   //MARK:- view handler
   override func viewDidLoad() {
    print ("Showing Donate tab")
      super.viewDidLoad()
    
    currentUser = UserDefaults.standard.string(forKey: "currentUser")
    self.confirmButton = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(confirm))
      navigationItem.rightBarButtonItem = self.confirmButton
      self.showSpinner(onView: self.view)
      self.tableview.delegate = self
      self.tableview.dataSource = self
      self.tableview.register(UINib(nibName: "DonateTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
      self.checkStatusDonor()
    if let _ = self.selectedData {
      performSegue(withIdentifier: "GoToStep", sender: nil)
    }
      self.setupTabledView {}
   }
  
  override func viewWillAppear(_ animated: Bool) {
    checkData()
  }
   
   override func viewDidAppear(_ animated: Bool) {
      profileImageNavBar(show: true)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      profileImageNavBar(show: false)
   }
  
  //Check udh login apa belom
  private func checkData(){
    if currentUser == nil {
      imageCoverView.image = UIImage(named: "have_not_login")
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
      if self.listRequest.count > 0 {
         self.coverView.isHidden = true
      }
      else {
         self.coverView.isHidden = false
      }
   }
   
  //MARK:- Get data from database
  private func getData(_ selectedCategory:Int = 0, completionHandler: @escaping (() -> Void)) {
    
    if currentUser != nil {
      print(self.currentUser!)
      var nspredicate = NSPredicate()
      if selectedCategory == 0 {
        nspredicate = NSPredicate(format: "id_pendonor == %@ AND current_step >= \(StepsEnum.donorFound_1)", CKRecord.ID(recordName: self.currentUser!))
      } else {
        nspredicate = NSPredicate(format: "id_pendonor IN %@ AND current_step == 6", [self.currentUser])
      }
      
      let query = CKQuery(recordType: "Tracker", predicate: nspredicate)
      Helper.getAllData(query) { (results) in
        if let results = results {
          DispatchQueue.main.async {
            self.listRequest = results
            self.checkCountListData()
            self.tableview.reloadData()
            self.removeSpinner()
            completionHandler()
          }
        }
      }
    }
    else if currentUser == nil {
      self.removeSpinner()
      print("User hasn't Login")
    }

  }
   
   private func checkStatusDonor() {
      if !self.statusDonor {
         self.switchButtonStatusDonor.isEnabled = false
      }
   }
   
   //MARK: - setup tableview
  private func setupTabledView(completionHandler: @escaping (() -> Void)) {
    self.getData {
      completionHandler()
    }
   }
   
  //MARK: - when segmented control tapped
  @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
    self.getData(sender.selectedSegmentIndex) {}
  }
  
  @objc private func confirm() {
    let storyboard = UIStoryboard(name: "Donate", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "StepsPageViewController") as! DonateStepsViewController
    present(vc, animated: true, completion: nil)
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
   
   
}

//MARK:- Table View handler

extension DonateController: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.listRequest.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! DonateTableViewCell
      cell.personImage.image = UIImage(named: "person_50")
      cell.titleLabel.text = "Permintaan donor \(indexPath.row+1)"
      cell.subtitleLabel.text = Steps.checkStep(
         self.listRequest[indexPath.row].value(
            forKey: "current_step") as! Int)
      return cell
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         print("ok")
      }
   }
   
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
         self.tableview.dataSource?.tableView?(self.tableview, commit: .delete, forRowAt: indexPath)
      })
      deleteButton.backgroundColor = Colors.red
      return [deleteButton]
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      self.selectedData = self.listRequest[indexPath.row].convertTrackerToTrackerModel()
      self.tableview.cellForRow(at: indexPath)?.isSelected = false
      performSegue(withIdentifier: "GoToStep", sender: tableView.cellForRow(at: indexPath))
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "GoToStep" {
         let senderr = sender as? DonateTableViewCell
         let stepVC = segue.destination as! DonateStepsViewController

        stepVC.request = self.selectedData
        
         stepVC.title = "Permintaan Darah 1"
      }
   }
}
