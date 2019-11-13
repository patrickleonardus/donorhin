//
//  AddController.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class AddEventController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleForHeaderInSection = ["DESKRIPSI ACARA","LOKASI DAN WAKTU","CONTACT PERSON"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        closeKeyboard()
    }
    
    //MARK: - Setup UI
    
    private func setNavBar(){
        let cancel = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = cancel
    }
    
    private func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboardAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func cancelAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func closeKeyboardAction(){
        view.endEditing(true)
    }

}

extension AddEventController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.bounds.size.width), height: 50))
        headerView.backgroundColor = Colors.backgroundView
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = titleForHeaderInSection[section]
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Colors.gray
       
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.5))
        separatorView.backgroundColor = Colors.gray_line
        
        headerView.addSubview(label)
        headerView.addSubview(separatorView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor,constant: 20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "descEvent") as! LabelAndTextFieldCell
        
        cell.name.text = "Test"
        cell.answer.placeholder = "Test"
        
        return cell
    }
    
    
}
