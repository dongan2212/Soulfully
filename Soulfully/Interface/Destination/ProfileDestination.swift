//
//  ProfileDestination.swift
//  Soulfully
//
//  Created by Vo The Dong An on 18/02/2022.
//

import UIKit

class ProfileDestination: Destinating {
	var viewModel: ProfileViewModel

	var view: UIViewController {
		return ProfileViewController(viewModel: viewModel)
	}

	init() {
		self.viewModel = ProfileViewModel()
	}
}
