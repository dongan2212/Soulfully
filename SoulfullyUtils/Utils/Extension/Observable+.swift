import Foundation
import RxSwift
import RxCocoa
import UIKit

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

extension Reactive where Base: UIButton {
//    public var isEnable: Binder<Bool> {
//        return Binder(self.base) { button, isEnable in
//            button.backgroundColor = isEnable ? ColorDefine.primary : ColorDefine.lightGray
//            button.setTitleColor(isEnable ? ColorDefine.onPrimary : .gray, for: .normal)
//            button.isEnabled = isEnable
//        }
//    }
//    
//    public var isValidate: Binder<Bool> {
//        return Binder(self.base) { button, isValidate in
//            button.layer.opacity = isValidate ? 1 : 0.3
//            button.isEnabled = isValidate
//        }
//    }
}
