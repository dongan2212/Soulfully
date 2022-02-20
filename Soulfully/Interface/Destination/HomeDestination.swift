//
//  HomeDestination.swift
//  amoda-ios
//
//  Created by MacOS on 04/05/2021.
//  Copyright © 2021 KST. All rights reserved.
//

import UIKit

class HomeDestination: Destinating {
  var viewModel: HomeViewModel
  
  var view: UIViewController {
    return HomeViewController(viewModel: viewModel)
  }
  
  init() {
    self.viewModel = HomeViewModel()
  }
}
