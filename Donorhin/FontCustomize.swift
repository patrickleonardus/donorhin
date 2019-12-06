//
//  FontCustomize.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 07/12/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit

protocol ChangableFont: AnyObject {
  var text: String? { get set }
  var attributedText: NSAttributedString? { get set }
  var rangedAttributes: [RangedAttributes] { get }
  func getFont() -> UIFont?
  func changeFont(ofText text: String, with font: UIFont)
  func changeFont(inRange range: NSRange, with font: UIFont)
  func changeTextColor(ofText text: String, with color: UIColor)
  func changeTextColor(inRange range: NSRange, with color: UIColor)
  func resetFontChanges()
}

public struct RangedAttributes {
  
  let attributes: [NSAttributedString.Key: Any]
  let range: NSRange
  
  public init(_ attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
    self.attributes = attributes
    self.range = range
  }
}

extension UILabel: ChangableFont {
  
  public func getFont() -> UIFont? {
    return font
  }
}

extension ChangableFont {
  
  public var rangedAttributes: [RangedAttributes] {
    guard let attributedText = attributedText else {
      return []
    }
    var rangedAttributes: [RangedAttributes] = []
    let fullRange = NSRange(
      location: 0,
      length: attributedText.string.count
    )
    attributedText.enumerateAttributes(
      in: fullRange,
      options: []
    ) { (attributes, range, stop) in
      guard range != fullRange, !attributes.isEmpty else { return }
      rangedAttributes.append(RangedAttributes(attributes, inRange: range))
    }
    return rangedAttributes
  }
  
  public func changeFont(ofText text: String, with font: UIFont) {
    guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
    changeFont(inRange: range, with: font)
  }
  
  public func changeFont(inRange range: NSRange, with font: UIFont) {
    add(attributes: [.font: font], inRange: range)
  }
  
  public func changeTextColor(ofText text: String, with color: UIColor) {
    guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
    changeTextColor(inRange: range, with: color)
  }
  
  public func changeTextColor(inRange range: NSRange, with color: UIColor) {
    add(attributes: [.foregroundColor: color], inRange: range)
  }
  
  private func add(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
    guard !attributes.isEmpty else { return }
    
    var rangedAttributes: [RangedAttributes] = self.rangedAttributes
    
    var attributedString: NSMutableAttributedString
    
    if let attributedText = attributedText {
      attributedString = NSMutableAttributedString(attributedString: attributedText)
    } else if let text = text {
      attributedString = NSMutableAttributedString(string: text)
    } else {
      return
    }
    
    rangedAttributes.append(RangedAttributes(attributes, inRange: range))
    
    rangedAttributes.forEach { (rangedAttributes) in
      attributedString.addAttributes(
        rangedAttributes.attributes,
        range: rangedAttributes.range
      )
    }
    
    attributedText = attributedString
  }
  
  public func resetFontChanges() {
    guard let text = text else { return }
    attributedText = NSMutableAttributedString(string: text)
  }
}

public extension String {
  
  func range(ofText text: String) -> NSRange {
    let fullText = self
    let range = (fullText as NSString).range(of: text)
    return range
  }
}
