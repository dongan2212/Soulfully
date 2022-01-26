//
//  Scrollable.swift
//  ServicePlatform
//
//

import RxCocoa
import RxSwift
import UIKit

// MARK: - TableView
// swiftlint:disable line_length
public extension UITableView {

  /// Adding a custom see more view that contains an activity indicator view
  ///
  /// - Parameter color: color of activity indicator, default is gray color
  func seeMoreFooter(color: UIColor = .gray) {
    self.tableFooterView = self.initializeIndicator()
  }

  /// Determine whether the last cell is visible on Screen or not
  func isLastCellVisible(reduce: CGFloat = 13) -> Bool {
    if let lastVisibleIdxPath = indexPathsForVisibleRows?.last {
      let lastSection = numberOfSections - 1
      let lastRow = numberOfRows(inSection: lastSection) - 1
      if lastSection == lastVisibleIdxPath.section && lastVisibleIdxPath.row == lastRow {
        if let cell = cellForRow(at: lastVisibleIdxPath) {
          cell.size.height -= reduce
          let rect = convert(cell.frame, to: superview)
          return frame.contains(rect)
        }
      }
    }
    return false
  }

  /// Getting indexpath of last cell
  var lastIndexPath: IndexPath {
    let lastSection = numberOfSections - 1
    let lastRow = numberOfRows(inSection: lastSection) - 1
    return IndexPath(row: lastRow, section: lastSection)
  }
  
  func register<T: UITableViewCell>(_ aClass: T.Type) {
    let name = String(describing: aClass)
    let bundle = Bundle.main
    if bundle.path(forResource: name, ofType: "nib") != nil {
      let nib = UINib(nibName: name, bundle: bundle)
      register(nib, forCellReuseIdentifier: name)
    } else {
      register(aClass, forCellReuseIdentifier: name)
    }
  }
  
  func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
    let name = String(describing: aClass)
    guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
      fatalError("`\(name)` is not registed")
    }
    return cell
  }
  
  func dequeue<T: UITableViewCell>(_ aClass: T.Type, for indexPath: IndexPath) -> T {
    let name = String(describing: aClass)
    guard let cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
      fatalError("`\(name)` is not registed")
    }
    return cell
  }
    
    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
      let name = String(describing: aClass)
      let bundle = Bundle.main
      if bundle.path(forResource: name, ofType: "nib") != nil {
        let nib = UINib(nibName: name, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: name)
      } else {
        register(aClass, forHeaderFooterViewReuseIdentifier: name)
      }
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
      let name = String(describing: aClass)
      guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
        fatalError("`\(name)` is not registed")
      }
      return cell
    }
}

public extension UIScrollView {

  var isAtTop: Bool {
    return contentOffset.y <= verticalOffsetForTop
  }

  var isAtBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }

  var verticalOffsetForTop: CGFloat {
    let topInset = contentInset.top
    return -topInset
  }

  var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
    return scrollViewBottomOffset
  }

  func scrollToBottom(animated: Bool = true) {
    let ypos = verticalOffsetForBottom
    let xpos = contentOffset.x
    setContentOffset(CGPoint(x: xpos, y: ypos), animated: animated)
  }

  func scrollToTop(animated: Bool = true) {
    setContentOffset(.zero, animated: animated)
  }
  
  func configRefreshControl(_ viewController: UIViewController) {
    let refresh = UIRefreshControl()
    refresh.tintColor = .orange
    self.refreshControl = refresh
  }
  
  func endRefresh() {
    self.refreshControl?.endRefreshing()
  }
}

public extension UIRefreshControl {
  
  func driver() -> Driver<()> {
    return self.rx.controlEvent(.valueChanged).asDriver()
  }
}

public extension UITableViewCell {

  func optimization() {
    /// Using masksToBounds on cell might leak memory and cause scrolling laggy
    /// These code will help to avoid this issue
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
}

public extension UICollectionViewCell {

  func optimization() {
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
}

// MARK: - UICollectionView
public extension UICollectionView {
  
  func scrollToIndexPathIfNotVisible(_ indexPath: IndexPath) {
    let section = indexPath.section
    if indexPath.row < self.numberOfItems(inSection: section) {
      self.scrollToItem(at: indexPath, at: [.bottom, .centeredHorizontally], animated: false)
    }
    self.layoutIfNeeded()
  }

  func scrollToAndGetCell(atIndexPath indexPath: IndexPath) -> UICollectionViewCell! {
    scrollToIndexPathIfNotVisible(indexPath)
    return self.cellForItem(at: indexPath)
  }
  
  /// SwifterSwift: Register UICollectionViewCell with .xib file using only its corresponding class.
  ///               Assumes that the .xib filename and cell class has the same name.
  ///
  /// - Parameters:
  ///   - name: UICollectionViewCell type.
  ///   - bundleClass: Class in which the Bundle instance will be based on.
  func register<T: UICollectionViewCell>(_ name: T.Type, at bundleClass: AnyClass? = nil) {
    let identifier = String(describing: name)
    var bundle: Bundle?
    
    if let bundleName = bundleClass {
      bundle = Bundle(for: bundleName)
    }
    
    register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
  }
  
  /// SwifterSwift: Dequeue reusable UICollectionViewCell using class name.
  ///
  /// - Parameters:
  ///   - name: UICollectionViewCell type.
  ///   - indexPath: location of cell in collectionView.
  /// - Returns: UICollectionViewCell object with associated class name.
  func dequeueReusableCell<T: UICollectionViewCell>(_ name: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
      fatalError("Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
    }
    return cell
  }
  
  /// Getting indexpath of last item
  var lastIndexPath: IndexPath {
    let lastSection = numberOfSections - 1
    let lastItem = numberOfItems(inSection: lastSection) - 1
    return IndexPath(row: lastItem, section: lastSection)
  }
}
