//
//  DonateController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class DonateController: UIViewController {

  @IBOutlet weak var switchButtonStatusDonor: UISwitch!
  @IBOutlet weak var historyDonorSegmentedControl: UISegmentedControl!
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var coverView: CustomMainView!
  final private let cellReuseIdentifier = "DonateCell"
  var selectedRow:Request?
  var segmented: History {
      if historyDonorSegmentedControl.selectedSegmentIndex == 0 {
        return .active
      } else {
        return.history
      }
  }
  var listData: [Request] = []
  var profileImage = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupTabledView()
    self.getData()
    if self.listData.count > 0 {
      self.coverView.isHidden = true
    }
    else {
      self.coverView.isHidden = false
    }
  }
  
  //MARK: - get data from database
  private func getData() {
    DummyDataDonate.getData(self.segmented) { (res) in
      if let res = res {
        self.listData = res
        self.tableview.reloadData()
      }
    }
  }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageNavBar(show: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImageNavBar(show: false)
    }
  
  //MARK: - setup tableview
  private func setupTabledView() {
    self.tableview.delegate = self
    self.tableview.dataSource = self
    self.tableview.register(UINib(nibName: "DonateTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
  }
  
  //MARK: - when segmented control tapped
  @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
    self.historyDonorSegmentedControl = sender
    DummyDataDonate.getData(self.segmented) { (req) in
      if let req = req {
        self.listData = req
        self.tableview.reloadData()
      }
    }
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
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: vc)
        self.present(navBarOnModal, animated: true, completion: nil)
    }
    
    
}

extension DonateController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.listData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! DonateTableViewCell
    cell.titleLabel.text = self.listData[indexPath.row].user
    cell.subtitleLabel.text = "\(self.listData[indexPath.row].step)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedRow = self.listData[indexPath.row]
    performSegue(withIdentifier: "GoToStep", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "GoToStep" {
      let stepVC = segue.destination as! DonateStepsViewController
      stepVC.request = self.selectedRow
    }
  }
}
