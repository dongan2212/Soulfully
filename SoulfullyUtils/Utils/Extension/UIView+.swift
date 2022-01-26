//
//  UIViewExtensions.swift
//  amoda-ios
//
//  Created by MacOS on 22/04/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import UIKit
import SnapKit

// swiftlint:disable identifier_name line_length file_length
public extension UIView {
    
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func roundBorder(radius: CGFloat,
                     width: CGFloat = 0,
                     color: CGColor = UIColor.clear.cgColor,
                     corners: UIRectCorner = .allCorners) {
        if corners == .allCorners {
            self.layer.cornerRadius = radius
            self.layer.borderWidth = width
            self.layer.borderColor = color
            self.layer.masksToBounds = true
        } else {
            let maskPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = bounds
            shapeLayer.path = maskPath.cgPath
            shapeLayer.borderColor = color
            shapeLayer.borderWidth = width
            layer.mask = shapeLayer
        }
    }
    
    func dashedBorder(radius: CGFloat, width: CGFloat = 0, color: CGColor = UIColor.clear.cgColor) {
        let  borderLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth = width
        borderLayer.cornerRadius = radius
        borderLayer.masksToBounds = true
        borderLayer.lineJoin = CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 5), NSNumber(value: 5)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
    
    func makeCircle() {
        self.layer.cornerRadius = self.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func makeShadow(opacity: Float = 0.5,
                    radius: CGFloat = 2,
                    height: CGFloat = 3,
                    color: UIColor = .gray,
                    bottom: Bool = true,
                    all: Bool = false) {
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        if all {
            self.layer.shadowOffset = .zero
        } else {
            let offset = bottom ? CGSize(width: 0, height: height): CGSize(width: height, height: 0)
            self.layer.shadowOffset = offset
        }
        self.layer.masksToBounds = false
    }
    
    func rotateCycle() {
        rotateAnimation(rad: .pi * 2, duration: 0.5)
    }
    
    static func createIndicator() -> UIImageView {
        let indicator = UIImageView(image: #imageLiteral(resourceName: "animLoadingGray"))
        indicator.size = CGSize(width: 30, height: 30)
        return indicator
    }
    
    func initializeIndicator(height: CGFloat = 50) -> UIView {
        let indicator = UIView.createIndicator()
        
        let seemoreView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        seemoreView.backgroundColor = .clear
        indicator.center = seemoreView.center
        seemoreView.addSubview(indicator)
        indicator.rotateAnimation(rad: .pi * 2, duration: 0.5)
        return seemoreView
    }
    
    func isKind(classNamed: String) -> Bool {
        if let targetClass = NSClassFromString(classNamed) {
            return self.isKind(of: targetClass)
        }
        return false
    }
    
    func toImage() -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return image
    }
    
    /// Convert origin point of sender's superview into another view's superview
    ///
    /// - Parameters:
    ///   - sender: target view
    ///   - view: destination view
    /// - Returns: converted point
    func convertOrigin(to view: UIView) -> CGPoint? {
        let sp2View = superview?.superview
        if let point1 = superview?.convert(frame.origin, to: sp2View),
           let point = sp2View?.convert(point1, to: view) {
            return point
        }
        return nil
    }
    
    /// A common function for loading view from nib
    ///
    /// - Returns: a view
    @discardableResult
    func fromNib<T: UIView>() -> T? {
        guard let view = UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil).first as? T else {
            return nil
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
    
    var x: CGFloat {
        get { return self.frame.x }
        set { self.frame.x = newValue }
    }
    
    var y: CGFloat {
        get { return self.frame.y }
        set { self.frame.y = newValue }
    }
    
    var width: CGFloat {
        get { return self.frame.width }
        set { self.frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return self.frame.height }
        set { self.frame.size.height = newValue }
    }
    
    var size: CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    
    var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame.origin = newValue }
    }
    
    var addSize: CGFloat {
        get { return 0 }
        set {
            width += newValue
            height += newValue
        }
    }
}

// Getting frame's components
public extension CGRect {
    
    var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    
    var doubleSize: CGSize {
        get { return CGSize(width: size.width * 2, height: size.height * 2) }
        set { self.size = newValue }
    }
    
    var addSize: CGFloat {
        get { return 0 }
        set {
            size.width += newValue
            size.height += newValue
        }
    }
    var subOrigin: CGFloat {
        get { return 0 }
        set {
            x -= newValue
            y -= newValue
        }
    }
}

extension CGSize {
    func math(_ f: (CGFloat, CGFloat) -> CGFloat, _ x: CGFloat) -> CGSize {
        return CGSize(width: f(width, x), height: f(height, x))
    }
}

extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var isMask: Bool {
        get {
            return layer.masksToBounds
        }
        
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
        }
        
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get {
            return self.layer.shadowOpacity.cgFloat
        }
        
        set {
            self.layer.shadowOpacity = newValue.float
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shouldRasterize: Bool {
        get {
            return self.layer.shouldRasterize
        }
        
        set {
            self.layer.shouldRasterize = newValue
        }
    }
    
    func makeCorner(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? height/2
        self.layer.masksToBounds = true
    }
    
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter { $0 is UIVisualEffectView }
        blurredEffectViews.forEach { $0.removeFromSuperview() }
    }
    
    func removeAllLayer() {
        self.layer.sublayers?.compactMap({$0}).forEach({ layer in
            layer.removeFromSuperlayer()
        })
    }
}

public extension UIView {
    static var loadNib: UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }
    
    func contentFromXib() -> UIView? {
        
        guard let contentView = type(of: self).loadNib.instantiate(withOwner: self, options: nil).last as? UIView else {
            return nil
        }
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        
        return contentView
    }
}

extension UIView {
    func makeBlur(style: UIBlurEffect.Style = .systemUltraThinMaterialDark) {
        if !UIAccessibility.isReduceTransparencyEnabled {
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.addSubview(blurEffectView)
            blurEffectView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        } else {
            self.backgroundColor = .white
            self.alpha = 0.8
        }
    }
}

extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blur: BlurView {
        get {
            if let blur = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
            ) as? BlurView {
                return blur
            }
            self.blur = BlurView(to: self)
            return self.blur
        }
        set(blur) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blur,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                      !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}
