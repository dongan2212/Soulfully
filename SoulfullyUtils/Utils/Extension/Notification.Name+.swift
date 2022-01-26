//
//  Notification.Name+.swift
//  amoda-ios
//
//  Created by NguyenPhamThienBao on 06/08/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
  static let resetTabbar = Notification.Name("RESET_TABBAR")
  static let reloadProducts = Notification.Name("RELOAD_PRODUCT")
  static let updateProductCell = Notification.Name("UPDATE_PRODUCT_CELL")
}

public protocol ReuseIdentifier {
  static var reuseIdentifier: String { get }
}
