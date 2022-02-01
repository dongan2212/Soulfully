//
//  BaseViewController.swift
//  amoda-ios
//

import UIKit
import RxSwift
import RxCocoa
import SoulfullyUtils

typealias Image = AppDefine.Image

class BaseViewController: UIViewController, Navigateable {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindingData()
        makeUI()
        setupAction()
        setupNav()
    }
    
    func setup() { }
    func bindingData() { }
    func makeUI() { }
    func setupAction() { }
    func setupNav() { }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    func enableSwipeGestures() {
        let swipedRight = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(swiperight))
        swipedRight.direction = .right
        self.view!.addGestureRecognizer(swipedRight)
    }
    
    func setupBackButton(title: String? = nil,
                         image: UIImage? = Image.icBack.toImage(),
                         tintColor: UIColor = ColorDefine.primary,
                         handle: Selector? = nil) {
        guard let icBack = image?.makeIcon(with: tintColor) else { return }
        let barButton = createBarButtonItem(image: icBack,
                                            contentEdgeInsets: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0),
                                            handle: handle != nil ? handle! : #selector(onBack))
        navigationItem.leftBarButtonItem = barButton
    }
    
    func createBarButtonItem(image: UIImage? = nil,
                             title: String? = nil,
                             imageEdgeInsets: UIEdgeInsets? = nil,
                             titleEdgeInsets: UIEdgeInsets? = nil,
                             contentEdgeInsets: UIEdgeInsets? = nil,
                             attributes: [NSAttributedString.Key: Any]? = nil,
                             handle: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(image ?? nil, for: .normal)
        if let attributes = attributes {
            button.setAttributedTitle(NSAttributedString(string: title.ignoreNil(),
                                                         attributes: attributes),
                                      for: .normal)
        } else {
            button.setTitle(title, for: .normal)
        }
        button.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 25))
        button.addTarget(self, action: handle, for: .touchUpInside)
        button.imageEdgeInsets = imageEdgeInsets ?? .zero
        button.titleEdgeInsets = titleEdgeInsets ?? .zero
        button.contentEdgeInsets = contentEdgeInsets ?? .zero
        button.imageView?.contentMode = .scaleAspectFit
        return UIBarButtonItem.init(customView: button)
    }
    
    @objc func swiperight(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            debugPrint("Swiped right!")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onDismiss() {
        self.dissmissViewController()
    }
}
