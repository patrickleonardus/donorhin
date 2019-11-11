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
  var listData = ListDonate.list
  var profileImage = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupTabledView()
    if self.listData.count > 0 {
      self.coverView.isHidden = true
    }
  }
    
    override func viewWillAppear(_ animated: Bool) {
        profileImageNavBar(show: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImageNavBar(show: false)
    }
  
  private func setupTabledView() {
    self.tableview.delegate = self
    self.tableview.dataSource = self
    self.tableview.register(UINib(nibName: "DonateTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
  }
    
    private func profileImageNavBar(show: Bool){
        
        if show {
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
    return cell
  }
}
