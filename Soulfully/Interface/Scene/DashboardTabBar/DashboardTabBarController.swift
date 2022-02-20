//
//  DashboardTabBarController.swift
//  SIA-Customer
//
//  Created by TuanVi on 4/10/18.
//  Copyright © 2018 cbb. All rights reserved.
// add

import LocalAuthentication
import RxSwift
import UIKit

public enum IndexTabbar: Int {
  case home = 0, discover, profile
}

final class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
  var homeDestination: HomeDestination!
  var discoverDestination: DiscoverDestination!
  var profileDestination: ProfileDestination!
  
  let disposeBag = DisposeBag()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    homeDestination = HomeDestination()
    setup3DBodyDestination = Setup3DBodyDestination()
    notificationDestination = NotificationDestination()
    userProfileDestination = UserProfileDestination()
    guestProfileDestination = GuestProfileDestination()
    
    setup()
    
    NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .resetTabbar, object: nil)
  }
  
  @objc func refresh() {
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
  }

  private func setup() {
    let homeNavigation = UINavigationController(rootViewController: homeDestination.view)
    let setup3DBodyNavigation = UINavigationController(rootViewController: setup3DBodyDestination.view)
    let notificationAndShopUpdateNavigation = UINavigationController(rootViewController: notificationDestination.view)
    let userProfileNavigation = UINavigationController(rootViewController: userProfileDestination.view)
    let guestProfileNavigation = UINavigationController(rootViewController: guestProfileDestination.view)
    let guestNotificationNavigation = UINavigationController(rootViewController: guestProfileDestination.view)
    
    let token = UDHelper.token
    let isRememberSignIn = UDHelper.isRemember
    let isGuest = UDHelper.isPresentedAuthentication ? false : (token.isEmpty || !isRememberSignIn)
    print("is guest \(isGuest)")
    let profileNavigation = isGuest ? guestProfileNavigation : userProfileNavigation
    let notificationNavigation = isGuest ? guestNotificationNavigation : notificationAndShopUpdateNavigation
    
    homeNavigation.tabBarItem = tabBarItem(for: .home)
    setup3DBodyNavigation.tabBarItem = tabBarItem(for: .setup3D)
    notificationNavigation.tabBarItem = tabBarItem(for: .notification)
    profileNavigation.tabBarItem = tabBarItem(for: .profile)
    
    self.viewControllers = [homeNavigation,
                            setup3DBodyNavigation,
                            notificationNavigation,
                            profileNavigation]
    self.selectedIndex = 0
    
    UDHelper.isPresentedAuthentication = false
    UDHelper.isLastTutorial = false
  }
	
	func tabBarItem(for type: IndexTabbar) -> UITabBarItem {
      let imageHome = UIImage(named: "ic_home").ignoreNil()
      let imageSetup3D = UIImage(named: "ic_setup3d").ignoreNil()
      let imageNotification = UIImage(named: "ic_notification").ignoreNil()
      let imageProfile = UIImage(named: "ic_profile").ignoreNil()
      
      let iconDefaultColor = ColorDefine.defaultTabItemColor
      let iconSelectedColor = ColorDefine.selectedTabItemColor
      
      var item: UITabBarItem
      switch type {
      case .home:
        item = UITabBarItem(title: nil,
                            image: imageHome.makeIcon(with: iconDefaultColor),
                            selectedImage: imageHome.makeIcon(with: iconSelectedColor))
      case .setup3D:
        item = UITabBarItem(title: nil,
                            image: imageSetup3D.makeIcon(with: iconDefaultColor),
                            selectedImage: imageSetup3D.makeIcon(with: iconSelectedColor))
      case .notification:
        item = UITabBarItem(title: nil,
                            image: imageNotification.makeIcon(with: iconDefaultColor),
                            selectedImage: imageNotification.makeIcon(with: iconSelectedColor))
      case .profile:
        item = UITabBarItem(title: nil,
                            image: imageProfile.makeIcon(with: iconDefaultColor),
                            selectedImage: imageProfile.makeIcon(with: iconSelectedColor))
      }
      item.tag = type.rawValue
      return item
	}
}
