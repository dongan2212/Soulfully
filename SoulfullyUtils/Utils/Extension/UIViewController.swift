import UIKit

public extension UIViewController {
    
    var statusBarManager: UIStatusBarManager? {
        return view.window?.windowScene?.statusBarManager
    }
    
    var statusBarFrame: CGRect {
        return statusBarManager?.statusBarFrame ?? .zero
    }
    
    var statusBarHeight: CGFloat {
        return statusBarFrame.height
    }
    
    var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.frame.height ?? .zero
    }
    
    var navigationControllerHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
    
}

public extension UIDevice {
  
    // Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *),
              let window = UIApplication.shared.keyWindow() else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
  
}
