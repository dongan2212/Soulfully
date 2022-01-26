//
//  Float+.swift
//  SoulfullyUtils
//
//  Created by Vo The Dong An on 26/01/2022.
//

import CoreGraphics
import Foundation

// MARK: - Properties
public extension Float {

    /// SwifterSwift: Double.
    var double: Double {
        return Double(self)
    }

    /// SwifterSwift: CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    /// SwifterSwift: Absolute of CGFloat value.
    var abs: CGFloat {
        return CGFloat(Swift.abs(self))
    }

    /// SwifterSwift: Ceil of CGFloat value.
    var ceil: CGFloat {
        return CGFloat(Foundation.ceil(self))
    }

    /// SwifterSwift: Radian value of degree input.
    var degreesToRadians: CGFloat {
        return CGFloat(.pi * self / 180.0)
    }

    /// SwifterSwift: Floor of CGFloat value.
    var floor: CGFloat {
        return CGFloat(Foundation.floor(self))
    }

    /// SwifterSwift: Check if CGFloat is positive.
    var isPositive: Bool {
        return self > 0
    }

    /// SwifterSwift: Check if CGFloat is negative.
    var isNegative: Bool {
        return self < 0
    }

    /// SwifterSwift: Int.
    var int: Int {
        return Int(self)
    }

    /// SwifterSwift: Float.
    var float: Float {
        return Float(self)
    }

}
