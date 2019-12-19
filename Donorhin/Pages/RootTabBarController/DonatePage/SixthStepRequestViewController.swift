//
//  SixthStepRequestViewController.swift
//  Donorhin
//
//  Created by Vebby Clarissa on 12/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

class SixthStepRequestViewController: DonateStepViewController {

  @IBOutlet var image: UIImageView!
  @IBOutlet var informationText: UILabel!
  let letter = "Resipien telah mengonfirmasi penerimaan darah yang Anda donorkan! Terimakasih atas bantuan berharga Anda."
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.informationText.text = letter
    self.image.image = UIImage(named: "request_sixth_step")
    
    }
    
  @IBAction func buttonPressed(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    guard let track = self.trackerModel else {return}
		Helper.getDataByID(track.idTracker) { (responseTracker) in
			if let _ = responseTracker {
				var params: [String:Any] = [:]
				params["current_step"] = 6
				self.trackerModel?.currentStep = 7
				DispatchQueue.main.async {
					self.pageViewDelegate?.changeShowedView(keyValuePair: params, tracker: self.trackerModel)
				}
			}
		}
  }
  
}
