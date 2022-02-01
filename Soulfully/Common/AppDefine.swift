//
//  AppDefine.swift
//  Soulfully
//
//  Created by Vo The Dong An on 01/02/2022.
//

import UIKit

enum AppDefine {
    enum Image: String {
        var desc: String {
            return rawValue
        }
        
        // Logo
        
        // Background
        
        // Icon
        case icBack = "ic_back"
        
        func toImage() -> UIImage? {
            return UIImage(named: self.desc)
        }
    }
}
