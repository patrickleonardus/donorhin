//
//  Service.swift
//  Donorhin
//
//  Created by Idris on 30/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import Foundation
struct Service {
  //MARK: - function for send notification
  
  static func sendNotification(_ message: String, _ token: [String],_ idRequest: String) {
    let url = URL(string: "https://server-donorhin.herokuapp.com")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    var parameters: [String:Any] = [:]
    parameters["message"] = message
    parameters["token"] = token
    parameters["id_request"] = idRequest
    let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
    request.httpBody = jsonData
    URLSession.shared.dataTask(with: request) { (data, res, err) in
      if let err = err {
        print(err.localizedDescription)
      }
    }.resume()
  }
}
