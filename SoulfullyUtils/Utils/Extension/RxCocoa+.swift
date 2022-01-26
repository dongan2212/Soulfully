import UIKit
import RxSwift
import RxCocoa

extension UITextField {
  public func driver() -> Driver<String> {
    return rx.text.orEmpty.asDriver()
  }
  
  public func value() -> Driver<String> {
    let text = rx.observe(String.self, "text").map({ $0 ?? "" }).asDriverOnErrorJustComplete()
    return Driver.merge(driver(), text).distinctUntilChanged()
  }
  
  public func onChange() -> Driver<String> {
    let event = rx.controlEvent(.editingChanged).asDriver()
    return Driver.combineLatest(driver(), event).map({ $0.0 })
  }
}
