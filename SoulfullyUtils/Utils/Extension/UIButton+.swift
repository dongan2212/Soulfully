//
//  Button.swift
//  ServicePlatform
//
//

import RxCocoa
import UIKit

public extension UIButton {

    /// Convenient function for making a Rx driver of Button
    ///
    /// - Returns: Rx driver
    func driver() -> Driver<Void> {
        return rx.tap.asDriver()
    }
}

extension UIButton {
  
    enum ImageDirection {
        case left, right
    }
  
  func addImage(_ image: UIImage, constant: CGFloat, color: UIColor, position: ImageDirection) {
      let viewSize = self.bounds.height
      // swiftlint:disable identifier_name
      let x = position == .left ? 0 : self.width - (viewSize / 3) * 2
      let view = UIView(frame: CGRect(x: x, y: 0, width: viewSize, height: viewSize))
      let imageView = UIImageView(image: image)
      imageView.tintColor = color
      let iconSize = viewSize/3
      view.addSubview(imageView)
      imageView.frame = CGRect(x: iconSize, y: iconSize, width: iconSize, height: iconSize)
      self.addSubview(view)
  }
    
}
