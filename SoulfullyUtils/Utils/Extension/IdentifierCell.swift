//
//  IdentifierCell.swift
//  amoda-ios
//
//  Created by NguyenPhamThienBao on 07/08/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import UIKit

public extension ReuseIdentifier {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReuseIdentifier {
    
}

extension UITableViewCell: ReuseIdentifier {
}
