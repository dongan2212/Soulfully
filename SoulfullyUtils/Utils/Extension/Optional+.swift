//
//  OptionalExtensions.swift
//  amoda-ios
//
//  Created by MacOS on 29/04/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import UIKit

extension Optional where Wrapped == String {
    func ignoreNil() -> String {
        self ?? ""
    }
}

extension Optional where Wrapped == Int {
    func ignoreNil() -> Int {
        self ?? 0
    }
}

extension Optional where Wrapped == Double {
    func ignoreNil() -> Double {
        self ?? 0.0
    }
}

extension Optional where Wrapped == Bool {
    func ignoreNil() -> Bool {
        self ?? false
    }
}

extension Optional where Wrapped == UIColor {
    func ignoreNil() -> UIColor {
        self ?? .black
    }
}

extension Optional where Wrapped == UIImage {
    func ignoreNil() -> UIImage {
        self ?? .init()
    }
}
