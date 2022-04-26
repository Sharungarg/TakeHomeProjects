//
//  ViewController.swift
//  DevicesManager
//
//  Created by Sharun Garg on 2022-04-25.
//

import UIKit

fileprivate enum MenuState {
    case open
    case close
}

class LandingContentViewController: UIViewController {
    
    let devicesListViewController: DevicesListViewController = {
        let viewController = DevicesListViewController(viewModel: DevicesListViewModel())
        return viewController
    }()
    
    let menuViewController: LandingMenuViewController = {
       return LandingMenuViewController()
    }()
    
    private var mainContentNavigationController: UINavigationController?
    private var menuViewState: MenuState = .close
    var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressMenuButton))
        self.addChildViews()
    }
    
    func addChildViews() {
        menuViewController.delegate = self
        self.addChild(menuViewController)
        self.view.addSubview(menuViewController.view)
        self.menuViewController.didMove(toParent: self)
        
        self.devicesListViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: self.devicesListViewController)
        self.addChild(navigationController)
        self.view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        self.mainContentNavigationController = navigationController
    }
    
    override func viewWillLayoutSubviews() {
        self.mainContentNavigationController?.view.frame.origin.x = 0.0
        self.menuViewState = .close
    }
}

extension LandingContentViewController: MenuButtonDelegate {
    @objc func didPressMenuButton() {
        switch self.menuViewState {
        case .open:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
                self.mainContentNavigationController?.view.frame.origin.x = 0.0
            } completion: { [weak self] animationDone in
                if animationDone {
                    self?.menuViewState = .close
                    self?.mainContentNavigationController?.view.removeGestureRecognizer((self?.tapGesture)!)
                }
            }
        case .close:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn) {
                let width = self.view.bounds.width
                self.mainContentNavigationController?.view.frame.origin.x = width - width/3
            } completion: { [weak self] animationDone in
                if animationDone {
                    self?.menuViewState = .open
                    self?.mainContentNavigationController?.view.addGestureRecognizer((self?.tapGesture)!)
                }
            }
        }
    }
}


extension LandingContentViewController: MenuViewDelegate {
    func didSelectMenuItem() {
        self.didPressMenuButton()
    }
}

