//
//  Label.swift
//  ServicePlatform
//
//

import UIKit

public extension UILabel {

  /// Measure height of text of self
  ///
  /// - Returns: size
  func sizeOfContent() -> CGSize {
    return sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude))
  }

  /// Measuring rect of text in self
  ///
  /// - Parameters:
  ///   - text: expected text
  ///   - range: range of text
  /// - Returns: rect
  func rectOfText(range: NSRange) -> CGRect {
    if let attributedText = attributedText {
      self.sizeToFit()
      let textStorage = NSTextStorage(attributedString: attributedText)
      let layoutManager = NSLayoutManager()
      textStorage.addLayoutManager(layoutManager)
      let textContainer = NSTextContainer(size: CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
      textContainer.lineFragmentPadding = 0
      textContainer.lineBreakMode = lineBreakMode
      textContainer.maximumNumberOfLines = numberOfLines
      layoutManager.addTextContainer(textContainer)
      var glyphRange = NSRange()
      // Convert the range for glyphs.
      layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
      // Expand touch area
      return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    return .zero
  }

  var lines: Int {
    let textSize = CGSize(width: width, height: CGFloat.infinity)
    let rHeight = lroundf(Float(sizeThatFits(textSize).height))
    let charSize = lroundf(Float(font.lineHeight))
    return rHeight/charSize
  }

  static func initialize(font: UIFont, color: UIColor) -> UILabel {
    let lb = UILabel()
    lb.font = font
    lb.textColor = color
    return lb
  }

  static func contentHeight(font: UIFont) -> (Int, CGFloat, String) -> CGFloat {
    let label = UILabel.initialize(font: font, color: .black)
    return { lines, width, content in
      DispatchQueue.main.async {
        label.numberOfLines = lines
        label.width = width
        label.text = content
        label.sizeToFit()
      }
      return label.height
    }
  }

  func setLineHeight(_ lineHeight: CGFloat) {
    let stringValue = self.text ?? ""
    var attrString: NSMutableAttributedString
    if let attributedText = self.attributedText {
      attrString = NSMutableAttributedString(attributedString: attributedText)
    } else {
      attrString = NSMutableAttributedString(string: stringValue)
    }
    let style = NSMutableParagraphStyle()
    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight
    style.alignment = self.textAlignment
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                            value: style,
                            range: NSRange(location: 0, length: stringValue.count))

    self.attributedText = attrString
  }
  
  func updatePriceText(for price: Double?,
                       font: UIFont = .systemFont(ofSize: 12),
                       fontCurrency: UIFont = .systemFont(ofSize: 9),
                       baseLineOffset: Int = 3) {
    guard let price = price else {
      self.isHidden = true
      return
    }
    self.isHidden = false
    let priceText = NumberFormatter.vietnamCurrency.string(from: NSNumber(value: price)) ?? ""
    let attributedPrice = NSMutableAttributedString(string: String(format: "%@đ", priceText),
                                                    attributes: [.font: font])
    if attributedPrice.setAsStylePrice(textToFind: "đ",
                                       fontCurrency: fontCurrency,
                                       baseLineOffset: baseLineOffset) {
      self.attributedText = attributedPrice
    } else {
      self.text = priceText
    }
  }
  
  func addSlantLine(slantLineColor: UIColor,
                    slantLineWidth: CGFloat,
                    startPoint: CGPoint,
                    endPoint: CGPoint) {
    let slantLinePath = UIBezierPath()
    slantLinePath.move(to: startPoint)
    slantLinePath.addLine(to: endPoint)
    
    let slantLineLayer = CAShapeLayer()
    slantLineLayer.path = slantLinePath.cgPath
    slantLineLayer.lineWidth = slantLineWidth
    slantLineLayer.strokeColor = slantLineColor.cgColor
    layer.addSublayer(slantLineLayer)
  }
}
