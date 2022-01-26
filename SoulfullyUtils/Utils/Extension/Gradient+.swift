//
//  Bar.swift
//  ServicePlatform
//
//
import UIKit

public extension CAGradientLayer {

  convenience init(frame: CGRect, colors: [UIColor]) {
    self.init()
    self.frame = frame
    self.colors = []
    for color in colors {
      self.colors?.append(color.cgColor)
    }
    startPoint = CGPoint(x: 0, y: -0.5)
    endPoint = CGPoint(x: 0, y: 1.5)
  }

  func createGradientImage() -> UIImage? {

    var image: UIImage?
    UIGraphicsBeginImageContext(frame.size)
    if let context = UIGraphicsGetCurrentContext() {
      render(in: context)
      image = UIGraphicsGetImageFromCurrentImageContext()
    }
    UIGraphicsEndImageContext()
    return image
  }
}
