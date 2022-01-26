//
//  TextView.swift
//  ServicePlatform
//
//

import UIKit

public extension UITextView {

    /// Determining position of cursor in textview
    ///
    /// - Returns: position
    func cursorPosition() -> CGPoint {
        if let start = selectedTextRange?.start {
            return caretRect(for: start).origin
        }
        return .zero
    }
    
    func autoHeight() -> CGFloat {
        let fixedWidth: CGFloat = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height
    }
    
    func lines() -> Int {
        if let lineHeight = font?.lineHeight {
            return Int((contentSize.height - textContainerInset.top - textContainerInset.bottom)/lineHeight)
        }
        return 0
    }
    
    func lineHeight() -> CGFloat {
        (self.font?.lineHeight ?? 1).rounded(.up)
    }
    
    func setLineHeight(_ lineHeight: CGFloat) {
        var attrString: NSMutableAttributedString
        if let attributedText = self.attributedText {
            attrString = NSMutableAttributedString(attributedString: attributedText)
        } else {
            attrString = NSMutableAttributedString(string: text)
        }
        let style = NSMutableParagraphStyle()
        //    style.lineSpacing = lineHeight
        style.lineHeightMultiple = lineHeight
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: style,
                                range: NSRange(location: 0, length: text.count))
        
        self.attributedText = attrString
    }
}
