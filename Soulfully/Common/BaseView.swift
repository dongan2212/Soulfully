//
//  BaseView.swift
//  amoda-ios
//
//  Created by MacOS on 22/04/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SoulfullyUtils

class BaseView: UIView {
    // MARK: - Properties
    var contentView: UIView?
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func setup() {
        guard let contentView = contentFromXib() else { return }
        self.contentView = contentView
        makeUI()
    }
    
    func makeUI() {}
}
