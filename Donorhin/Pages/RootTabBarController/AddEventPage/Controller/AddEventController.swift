//
//  AddController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CloudKit

class AddEventController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleForHeaderInSection = ["DESKRIPSI ACARA","LOKASI DAN WAKTU","CONTACT PERSON"]
    var cellName : [TitleModelEvent]?
    var cellPlaceholder : [PlaceholderModelEvent]?
    
    var fixedImage : UIImage?
    var shareBarButton : UIBarButtonItem?
    
    var checkboxValidation = false
    
    //MARK: - Initialize data jawaban user
    var titleEvent: String?
    var descEvent: String?
    var imageEvent: UIImage?
    var locEvent: String?
    var startEvent: String?
    var endEvent: String?
    var nameEvent: String?
    var phoneEvent: String?
    var userUID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        closeKeyboard()
        handleTableView()
        
        EventData().getEvent { (title) in
            self.cellName = title
        }
        
        EventData().getPlaceholder { (placeholder) in
            self.cellPlaceholder = placeholder
        }
        
    }
    
    //MARK: - Setup UI
    
    private func setNavBar(){
        let cancel = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(cancelAction))
        shareBarButton = UIBarButtonItem(title: "Bagikan Acara", style: .done, target: self, action: #selector(shareAction))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = shareBarButton
        
        shareBarButton!.isEnabled = false
    }
    
    private func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboardAction))
        view.addGestureRecognizer(tap)
    }
    
    private func handleTableView(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        let info = notification.userInfo
        let keyboardFrame = info![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        
        if let keyboardSize = keyboardFrame?.cgRectValue.size {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - Action
    
    @objc func shareAction(){
        
        if !checkboxValidation {
            errorAlert(title: "Formulir Belum Lengkap", message: "Harap mencentang kotak untuk memberikan persetujuan")
        }
        
        else {
            
            userUID = UserDefaults.standard.string(forKey: "currentUser")
            
            let record = CKRecord(recordType: "Request")
            record.setValue(CKRecord.Reference(recordID: CKRecord.ID(recordName: userUID!), action: .none), forKey: "reference_account")
            record.setValue(titleEvent, forKey: "title")
            record.setValue(descEvent, forKey: "description")
            record.setValue(locEvent, forKey: "address")
            record.setValue(imageEvent, forKey: "image")
            record.setValue(startEvent, forKey: "start_time")
            record.setValue(endEvent, forKey: "end_time")
            record.setValue(nameEvent, forKey: "contact_name")
            record.setValue(phoneEvent, forKey: "contact_phone")
            
            let database = CKContainer.default().publicCloudDatabase
            
            database.save(record) { (resutls, error) in
                if error != nil {
                    print("Error while saving to CloudKit [AddEventController.swift]\n", error!.localizedDescription)
                    self.errorAlert(title: "Terjadi Kesalahan", message: "Tidak dapat memposting acara, mohon periksa kembali bagian yang sudah anda isi dan coba kembali dalam beberapa saat")
                }
                else {
                    print("Successfully saved data to CloudKit")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func cancelAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeKeyboardAction(){
        view.endEditing(true)
    }
    
    @objc func pickPicture(){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Ambil Foto dari Kamera", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePicker, animated: true)
            }
            
        }
        
        let chooseFromAlbum = UIAlertAction(title: "Pilih Foto dari Album", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true)
            }
        }
        
        let cancel = UIAlertAction(title: "Batalkan", style: .cancel, handler: nil)
        
        alert.addAction(takePhoto)
        alert.addAction(chooseFromAlbum)
        alert.addAction(cancel)
        
        self.present(alert,animated: true)
    }
    
    //MARK : - Handle Date Picker
    
    @objc func showDatePickerStart(sender: UITextField){
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedStart(sender:)), for: .valueChanged)
    }
    
    @objc func showDatePickerEnd(sender: UITextField){
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedEnd(sender:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChangedStart(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        if let startDateCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 1)) as? LabelAndTextFieldCell {
             startDateCell.answer.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @objc func datePickerValueChangedEnd(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        if let endDateCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 1)) as? LabelAndTextFieldCell {
            endDateCell.answer.text = dateFormatter.string(from: sender.date)
        }
    }
    
    //MARK: - Handle Validasi
    
    func checkValidity(){
        if  (titleEvent != nil &&
            descEvent != nil &&
            locEvent != nil &&
            startEvent != nil &&
            endEvent != nil &&
            nameEvent != nil &&
            phoneEvent !=  nil) {
            
            shareBarButton?.isEnabled = true
        }
            
        else {
            shareBarButton?.isEnabled = false
        }
    }
    
    //MARK: - show alert
    
    func errorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
}
