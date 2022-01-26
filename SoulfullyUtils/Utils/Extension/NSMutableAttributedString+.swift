//
//  NSMutableAttributedStringExtension.swift
//  amoda-ios
//
//  Created by Vo The Dong An on 5/31/21.
//  Copyright © 2021 KST. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
  func setAsStylePrice(textToFind: String,
                       fontCurrency: UIFont = .systemFont(ofSize: 9),
                       baseLineOffset: Int = 3) -> Bool {
    let foundRange = self.mutableString.range(of: textToFind)
    if foundRange.location != NSNotFound {
      self.addAttributes([.font: fontCurrency, .baselineOffset: baseLineOffset], range: foundRange)
      return true
    }
    return false
  }
}
