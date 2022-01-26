//
//  ObservableExt.swift
//  ServicePlatform
//
//
import Foundation
import RxSwift
import RxCocoa

// MARK: - RxSwift
extension Optional: OptionalType {

  public var optional: Wrapped? { return self }
  public var notNil: Bool {
    return self != nil
  }
  public var isNil: Bool {
    return self == nil
  }
  
  public var unWrap: String {
    if let number = self as? NSNumber {
      return "\(number)"
    }
    return self as? String ?? ""
  }
  
  public var unWrapArray: [String] {
    return self as? [String] ?? []
  }
    
  public var unWrapDic: [String: String] {
    return self as? [String: String] ?? [:]
  }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType {
    internal func ignoreNil() -> Driver<Element.Wrapped> {
    return flatMap { value in
      value.optional.map { Driver<Element.Wrapped>.just($0) } ?? Driver<Element.Wrapped>.empty()
    }
  }
}

public extension Observable {

  func asDriver(_ def: Element) -> Driver<Element> {
    return asDriver(onErrorJustReturn: def)
  }

  func void() -> Observable<Void> {
    return map { _ in }
  }
}

public extension SharedSequenceConvertibleType {

  func void() -> SharedSequence<SharingStrategy, Void> {
    return map { _ in }
  }
}
