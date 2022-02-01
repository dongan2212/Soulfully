//
//  TextField.swift
//  ServicePlatform
//
//

import RxCocoa
import UIKit

public extension UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        get {
            return self.leftImage
        }
        set {
            guard let ic = newValue else { return }
            addImage(ic, color: tintColor, direction: .left)
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        get {
            return self.rightImage
        }
        set {
            guard let ic = newValue else { return }
            addImage(ic, color: tintColor, direction: .right)
        }
    }
    
    enum Direction {
        case left, right
    }
    
    func addImage(_ image: UIImage, color iconColor: UIColor, direction: Direction) {
        let viewSize = self.bounds.height
        let view = UIView(frame: CGRect(x: 0, y: 0, width: viewSize/2, height: viewSize))
        let imageView = UIImageView(image: image)
        imageView.tintColor = iconColor
        let iconSize = viewSize/3
        view.addSubview(imageView)
        imageView.frame = CGRect(x: iconSize/3, y: iconSize, width: iconSize, height: iconSize)
        
        if direction == .left {
            self.leftViewMode = .always
            self.leftView = view
        } else if direction == .right {
            self.rightViewMode = .always
            self.rightView = view
        }
    }
}

extension UITextField {
    
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneAction))
//        doneButton.tintColor = UserManager.shared.appConfiguration.appTheme.primaryTextColor
        
        let items = [flexSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
        
    @objc func doneAction() {
        self.resignFirstResponder()
    }
    
    @objc func cancelAction() {
        self.resignFirstResponder()
    }
}

public extension UITextField {
    
    /// Changing self placeholder font by inputting font
    ///
    /// - Parameter font: Font that placeholder need to be changed to
    func changePlaceholder(color: UIColor, font: UIFont) {
        let attributes = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: font]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
    }
}

public extension UITextView {
    
    /// Convenient function for making a Rx driver of textview
    ///
    /// - Returns: Rx driver
    func driver() -> Driver<String> {
        return rx.text.orEmpty.asDriver()
    }
    
    func value() -> Driver<String> {
        let f = rx.observe(String.self, "text").map({ $0 ?? "" }).asDriver("")
        return Driver.merge(driver(), f).distinctUntilChanged()
    }
    
    func onChange() -> Driver<String> {
        let event = rx.didChange.asDriver()
        return Driver.combineLatest(driver(), event).map({ $0.0 })
    }
}

public extension UISearchBar {
    
    /// Convenient function for making a Rx driver of textfield
    ///
    /// - Returns: Rx driver
    func driver() -> Driver<String> {
        return rx.text.orEmpty.asDriver()
    }
    
    func value() -> Driver<String> {
        let f = rx.observe(String.self, "text").map({ $0 ?? "" }).asDriver("")
        return Driver.merge(driver(), f).distinctUntilChanged()
    }
}
