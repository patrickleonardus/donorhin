
//
//  TrackerTableViewCell.swift
//  Donorhin
//
//  Created by Annisa Nabila Nasution on 13/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import WebKit

class InformationTableViewCell: UITableViewCell {
  
  @IBOutlet weak var longTextLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var firstContactLabel: UILabel!
  @IBOutlet weak var firstContactButton: UIButton!
  @IBOutlet weak var secondContactLabel: UILabel!
  @IBOutlet weak var secondContactButton: UIButton!
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var videoLayer: UIView!
  @IBOutlet var firstButtonTopConstraint: NSLayoutConstraint!
  @IBOutlet var secondButtonTopConstraint: NSLayoutConstraint!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.videoLayer.layer.cornerRadius = 10
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
