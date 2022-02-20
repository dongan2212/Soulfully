//
//  SignInUpInfoView.swift
//  Soulfully
//
//  Created by Vo The Dong An on 17/02/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SkyFloatingLabelTextField

class SignInUpInfoView: BaseView {

	// MARK: - IBOutlets
	@IBOutlet private weak var inputStackView: UIStackView!
	@IBOutlet private weak var emailTextField: SkyFloatingLabelTextField!
	@IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!

	// MARK: - Properties
	var email: Driver<String> { return emailTextField.value() }
	var password: Driver<String> { return passwordTextField.value() }

	override func setup() {
		super.setup()
	}
}
