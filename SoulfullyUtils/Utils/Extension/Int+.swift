import UIKit

public extension Int {
  func toLessThanOneHundredText() -> String {
    if self < 0 { return "" }
    return self < 100 ? "\(self)" : "99+"
  }
}

extension Int {
  var scale: CGFloat {
    return CGFloat(self) * ScaleFactor.default
  }
}
