//
//  OptionalExtensions.swift
//  amoda-ios
//
//  Created by MacOS on 29/04/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import UIKit

public extension Optional where Wrapped == String {
    func ignoreNil() -> String {
        self ?? ""
    }
}

public extension Optional where Wrapped == Int {
    func ignoreNil() -> Int {
        self ?? 0
    }
}

public extension Optional where Wrapped == Double {
    func ignoreNil() -> Double {
        self ?? 0.0
    }
}

public extension Optional where Wrapped == Bool {
    func ignoreNil() -> Bool {
        self ?? false
    }
}

public extension Optional where Wrapped == UIColor {
    func ignoreNil() -> UIColor {
        self ?? .black
    }
}

public extension Optional where Wrapped == UIImage {
    func ignoreNil() -> UIImage {
        self ?? .init()
    }
}
