//
//  DiscoverDestination.swift
//  Soulfully
//
//  Created by Vo The Dong An on 18/02/2022.
//

import UIKit

class DiscoverDestination: Destinating {
	var viewModel: DiscoverViewModel

	var view: UIViewController {
		return DiscoverViewController(viewModel: viewModel)
	}

	init() {
		self.viewModel = DiscoverViewModel()
	}
}
