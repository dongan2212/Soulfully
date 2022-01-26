//
//  Color.swift
//  ServicePlatform
//
//

import Foundation
import UIKit

// swiftlint:disable identifier_name
public extension UIColor {
  
  convenience init(hex: String) {
    let scanner = Scanner(string: hex)
    scanner.currentIndex = hex.startIndex
    
    var rgbValue: UInt64 = 0
    
    scanner.scanHexInt64(&rgbValue)
    
    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff
    
    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff, alpha: 1
    )
  }
}
