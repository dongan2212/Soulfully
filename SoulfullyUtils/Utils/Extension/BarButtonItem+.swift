//
//  BarButtonItem.swift
//  ServicePlatform
//
//

import RxCocoa
import UIKit

public extension UIBarButtonItem {
  
  /// Convenient function for making a Rx driver of BarButtonItem
  ///
  /// - Returns: Rx driver
    func driver() -> Driver<Void> {
        return rx.tap.asDriver()
    }
    
    func getFrame() -> CGRect {
        guard let view = self.value(forKey: "view") as? UIView else {
            return CGRect.zero
        }
        return view.frame
    }
}
