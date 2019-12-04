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
  let currentUser = UserDefaults.standard.value(forKey: "currentUser") as! String
   
   //MARK:- view handler
   override func viewDidLoad() {
      super.viewDidLoad()
    self.confirmButton = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(confirm))
      navigationItem.rightBarButtonItem = self.confirmButton
      self.showSpinner(onView: self.view)
      self.tableview.delegate = self
      self.tableview.dataSource = self
      self.tableview.register(UINib(nibName: "DonateTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
      self.setupTabledView()
      self.checkStatusDonor()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      profileImageNavBar(show: true)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      profileImageNavBar(show: false)
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
  private func getData() {
    let nspredicate = NSPredicate(format: "idPendonor == %@", [self.currentUser])
    let query = CKQuery(recordType: "Tracker", predicate: nspredicate)
    Helper.getAllData(query) { (results) in
       if let results = results {
          DispatchQueue.main.async {
             self.listRequest = results
             self.checkCountListData()
             self.tableview.reloadData()
             self.removeSpinner()
          }
       }
    }
  }
   
   private func checkStatusDonor() {
      if !self.statusDonor {
         self.switchButtonStatusDonor.isEnabled = false
      }
   }
   
   //MARK: - setup tableview
   private func setupTabledView() {
      self.getData()
   }
   
   //MARK: - when segmented control tapped
   @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
      self.historyDonorSegmentedControl = sender
      //    DummyDataDonate.getData(self.segmented) { (req) in
      //      if let req = req {
      //        self.listData = req
      //        self.tableview.reloadData()
      //      }
      //    }
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
      performSegue(withIdentifier: "GoToStep", sender: tableView.cellForRow(at: indexPath))
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "GoToStep" {
         let senderr = sender as? DonateTableViewCell
         let stepVC = segue.destination as! DonateStepsViewController

        stepVC.request = self.selectedData
        
         stepVC.title = senderr?.titleLabel.text
      }
   }
}
