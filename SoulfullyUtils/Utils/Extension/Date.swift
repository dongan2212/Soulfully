//
//  DateExtensions.swift
//  amoda-ios
//
//  Created by MacOS on 26/04/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation

extension Date {
  public enum DateFormat: String {
    case ddMMyyyy = "dd/MM/yyyy"
    case yyyyMMdd = "yyyy-MM-dd"
    case ddMMyy = "dd/MM/yy"
    case MMyy = "MM/yy"
    case MMyyyy = "MM/yyyy"
    case yyyyMMddhhmmss = "yyyy-MM-dd hh:mm:ss"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case ddMMyyyyhhMMa = "dd MMM yyyy hh:mma"
    case ddMMMyyyy = "dd MMM yyyy"
  }
  
  public init(_ dateString: String, format: DateFormat, localized: Bool = true) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    dateFormatter.timeZone = localized ? TimeZone.current : TimeZone(abbreviation: "UTC")
    dateFormatter.locale = Locale(identifier: Locale.current.identifier)
    
    if let date = dateFormatter.date(from: dateString) {
      self.init(timeInterval: 0, since: date)
    } else {
      self.init(timeInterval: 0, since: Date())
    }
  }
  
  func format(to format: DateFormat, localized: Bool = true) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = localized ? TimeZone.current : TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = format.rawValue
    return dateFormatter.string(from: self)
  }
}
extension Date {
    func dateToString(format: String,
                      locale: Locale = Locale(identifier: "vn"),
                      timeZone: TimeZone? = TimeZone.current) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = locale
      dateFormatter.timeZone = timeZone
      dateFormatter.dateFormat = format
      let myDate = dateFormatter.string(from: self)
      return myDate
    }
}
