//
//  Formatter.swift
//  ServicePlatform
//
//  Created by Vo The Dong An on 5/31/21.
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation

public extension NumberFormatter {
  
  static let vietnamCurrency: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    formatter.secondaryGroupingSize = 3
    formatter.currencyDecimalSeparator = ","
    return formatter
  }()
  
}

public extension NumberFormatter {

  static let decimalFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.generatesDecimalNumbers = true
      formatter.decimalSeparator = "."
      formatter.numberStyle = .decimal
      return formatter
  }()

  static let separatorFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.groupingSeparator = ","
      formatter.numberStyle = .decimal
      formatter.secondaryGroupingSize = 3
      return formatter
  }()

  static func decimalFormatter(minimumDigits: Int = 3) -> NumberFormatter {
      decimalFormatter.minimumFractionDigits = minimumDigits
      return decimalFormatter
  }
  
  static let commaFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    formatter.secondaryGroupingSize = 3
    return formatter
  }()
  
  static let downgradeToThousandFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1
    return formatter
  }()
}

extension Numeric {
  
  func toDecimalString() -> String {
    guard let value = NumberFormatter.decimalFormatter().string(for: self) else {
      return ""
    }
    return value
  }
  
  func toSeparatorString() -> String {
    guard let value = NumberFormatter.separatorFormatter.string(for: self) else {
      return ""
    }
    return value
  }
  
  func toString() -> String {
    return "\(self)"
  }
}
