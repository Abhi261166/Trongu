//
//  UIViewController+Custom.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 04/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeChid() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    
    func dismisController(with view:UIView, complition:@escaping() -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { finished in
            self.dismiss(animated: false) {
                DispatchQueue.main.async {
                    complition()
                }
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func pushViewController(_ viewController: UIViewController, _ isAnimated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    @objc func popViewController(_ isAnimated: Bool) {
        self.navigationController?.popViewController(animated: isAnimated)
    }
    
    @objc func popToRootViewController(_ isAnimated: Bool) {
        self.navigationController?.popToRootViewController(animated: isAnimated)
    }
    
    func share(items:[Any]) {
        DispatchQueue.main.async {
            let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
            self.present(vc, animated: true)
        }
    }
    
    @objc func back(_ button:UIButton) {
        self.popViewController(true)
    }
    
    func showAlert(message: String, title: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, title: String?, complition:@escaping()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { ha in
            complition()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { cencel in
            self.dismiss(animated: true)
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    
//    var currentViewController: UIViewController? {
//        if let window = Singleton.window {
//            if let menuController = window.rootViewController as? SWRevealViewController {
//                if let tabCon = menuController.frontViewController as? ESTabBarController {
//                    print("tabbar con \(tabCon)")
//                    if let navCon = tabCon.selectedViewController as? UINavigationController {
//                        print("nav con \(navCon)")
//                        if let currentCon = navCon.visibleViewController {
//                            print("curr con \(currentCon)")
//
//                        }
//                    }
//                }
//            }
//        }
//        return nil
//    }
    
    
//    var tabBarController: ESTabBarController? {
//        if let window = Singleton.window {
//            if let menuController = window.rootViewController as? SWRevealViewController {
//                if let tabCon = menuController.frontViewController as? ESTabBarController {
//                    print("tabbar con \(tabCon)")
//                    return tabCon
//                }
//            }
//        }
//        return nil
//    }
    
    func present(_ viewController:UIViewController, _ animated: Bool) {
        self.present(viewController, animated: animated, completion: nil)
    }
    
//    func getBanner(url:String?, picker:PickerData?) -> Banner {
//        let banner = Banner()
//        banner.added_on = Date().toString(format: .full1)
//        banner.modified_on = Date().toString(format: .full1)
//        banner.file_name = picker?.fileName
//        banner.url = url
//        banner.user_id = UserDefaultsCustom.getUserData()?._id
//        banner.file_size = picker?.fileSize
//        return banner
//    }
    
}

extension NSObject {
    
//    func showMessage(message:String, isError:ERROR_TYPE) {
//        Singleton.shared.showErrorMessage(error: message, isError: isError)
//    }
//    static func showMessage(message:String, isError:ERROR_TYPE) {
//        Singleton.shared.showErrorMessage(error: message, isError: isError)
//    }
    
//    var window: UIWindow? {
//        return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
//    }
    
    static var window: UIWindow? {
        return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
    }
}
