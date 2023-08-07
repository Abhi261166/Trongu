//
//  RootNavigationController.swift
//  meetwise
//
//  Created by Nitin Kumar on 07/09/20.
//  Copyright © 2020 Nitin Kumar. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    // MARK: - Private Properties
    fileprivate var duringPushAnimation = false
    
    
    // MARK: - Lifecycle
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This needs to be in here, not in init
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Overrides
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
    
}

// MARK : - UINavigationControllerDelegate
extension RootNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? RootNavigationController else { return }
        swipeNavigationController.duringPushAnimation = false
    }
}

// MARK : - UIGestureRecognizerDelegate
extension RootNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return (viewControllers.count > 1) && (duringPushAnimation == false)
    }
    
}
