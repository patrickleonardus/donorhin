//
//  LoginController.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 14/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CoreLocation
import LocalAuthentication
import CloudKit

class LoginController : UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var formTableView: UITableView!
    var navigationBarTitle : String?
    var formItems: [FormItems]?
    var context = LAContext()
    let locationManager = CLLocationManager()
    
    //available states
    var state = AuthenticationState.loggedout {
        didSet {
            
        }
    }
        
    override func viewDidLoad(){
        super.viewDidLoad()
        FormBuilder().getItemsForLogin { (formItems) in
            self.formItems = formItems
        }
        self.view.backgroundColor = Colors.backgroundView
        loadFormTable()
        setNavBarTitle()
    }
    
    func loadFormTable(){
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.register(UINib(nibName: "FormCustomCell", bundle: nil), forCellReuseIdentifier: "formCell")
        formTableView.register(UINib(nibName: "ButtonViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
        formTableView.register(UINib(nibName: "ErrorMessageViewCell", bundle: nil), forCellReuseIdentifier: "errorMsgCell")
        formTableView.register(UINib(nibName: "TwoButtonCell", bundle: nil), forCellReuseIdentifier: "twoButtonCell")
        formTableView.tableFooterView = UIView()
        formTableView.showsVerticalScrollIndicator = false
    }
    
    @objc func goToFindWithoutLogin(){
        navigationController?.navigationBar.isHidden = true
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @objc func goToRegister(){
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    func setNavBarTitle() {
        navigationItem.title =  "Masuk"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func validationCredential(email: String, password: String) {
        guard let emailCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FormTableViewCell else {return}
        guard let passCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? FormTableViewCell else {return}
        guard let buttonCell = formTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? ErrorMessageTableViewCell else {return}
        
        DataFetcher().getUserDataByEmail(email: email, password: password){(userModel) in
            guard userModel != nil else {
                DispatchQueue.main.async {
                    print("*Email or password not valid")
                    buttonCell.errorMsg.isHidden = false
                    emailCell.shake()
                    passCell.shake()
                    buttonCell.errorMsg.text = "*Email atau password tidak valid"
                }
                return
            }
            DispatchQueue.main.async {
                print("Processing...")
                self.checkLocation()
                UserDefaults.standard.set(userModel?.email, forKey: "email")
                UserDefaults.standard.set(userModel?.password, forKey: "password")
                UserDefaults.standard.set(userModel?.name, forKey: "name")
                UserDefaults.standard.set(userModel?.bloodType.rawValue, forKey: "blood_type")
                UserDefaults.standard.set(userModel?.birthdate, forKey: "birth_date")
                UserDefaults.standard.set(userModel?.gender.rawValue, forKey: "gender")
                UserDefaults.standard.set(userModel?.isVerified, forKey: "isVerified")
                UserDefaults.standard.set(userModel?.lastDonor, forKey: "last_donor")
                UserDefaults.standard.set(userModel?.statusDonor, forKey: "donor_status")
                print("Data saved to user default...")
                self.state = .loggedin
                buttonCell.errorMsg.isHidden = true
                self.navigationController?.navigationBar.isHidden = true
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }
    
    func checkLocation(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { fatalError() }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let location = locations.last!
        let recordName = UserDefaults.standard.value(forKey: "currentUser") as! String
        let recordId = CKRecord.ID(recordName: recordName)
        
        let package : [String:CLLocation] = ["location": location]
        Helper.updateToDatabase(keyValuePair: package, recordID: recordId)
        //masih failed
//
//        Helper.database.save(record) { (res,error) in
//            if error != nil{
//                print(error)
//            }
//            else {
//                print("success")
//            }
//        }
//
//        Helper.saveData(record) { (isSuccessfullySaved) in
//            if isSuccessfullySaved != false{
//                print("success")
//            }
//            else {
//                print("failed")
//            }
//        }
        
        // saving your CLLocation object
        let locationData = NSKeyedArchiver.archivedData(withRootObject: location)
        UserDefaults.standard.set(locationData, forKey: "location")

        // loading it
        if let loadedData = UserDefaults.standard.data(forKey: "locationData") {
            if let loadedLocation = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? CLLocation {
                print(loadedLocation.coordinate.latitude)
                print(loadedLocation.coordinate.longitude)
            }
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
