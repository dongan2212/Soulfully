//
//  ApplicationExt.swift
//  ServicePlatform
//
//

import Foundation
import UIKit

// swiftlint:disable line_length
public extension UIApplication {
  
  class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
  
  var heightStatusBar: CGFloat {
    windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
  }
	
  func keyWindow() -> UIWindow? {
	  UIApplication.shared.connectedScenes
			  .filter({$0.activationState == .foregroundActive})
			  .map({$0 as? UIWindowScene})
			  .compactMap({$0})
			  .first?.windows
			  .filter({$0.isKeyWindow}).first
  }
}
