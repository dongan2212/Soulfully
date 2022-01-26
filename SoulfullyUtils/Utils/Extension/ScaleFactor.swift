import UIKit

class AppScreenSize {
    static let baseWidth: CGFloat = 375.0
    static let baseHeigh: CGFloat = 667.0
    static let higherHeigh: CGFloat = 812.0
}

struct ScaleFactor {
    static let `default` = UIScreen.mainWidth / AppScreenSize.baseWidth
    static let horizontal = `default`
    static let vertical = `default`
    static let font = `default`
    static let byHeight = UIScreen.mainHeight / AppScreenSize.baseHeigh
    static let byHigherHeight = UIScreen.mainHeight / AppScreenSize.higherHeigh
}
