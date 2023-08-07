//
//  UIStoryboard.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 30/03/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
    
    static func setHomeScreen() {
        guard let window = NSObject.window else { return }
        let module = UIStoryboard.rootController(identifier: STORYBOARD_ID.homeNavigation) as? UINavigationController
        window.rootViewController = module
        window.makeKeyAndVisible()
    }
    
    static func setLoginScreen(window:UIWindow?) {
        let module = UIStoryboard.loginController(identifier: STORYBOARD_ID.loginNavigation) as? UINavigationController
        window?.frame = SCREEN_SIZE
        window?.rootViewController = module
        window?.makeKeyAndVisible()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: STORYBOARD.main, bundle: Bundle.main)
    }
    
    static func rootController(identifier:String) -> UIViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    static var loginStoryboard: UIStoryboard {
        return UIStoryboard(name: STORYBOARD.login, bundle: Bundle.main)
    }
    
    static func loginController(identifier:String) -> UIViewController {
        return loginStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    //MARK: - NAVIGATION CONTROLLERS
    
    class var dashboardNavigation: UINavigationController {
        return self.rootController(identifier: STORYBOARD_ID.dashboardNavigation) as! RootNavigationController
    }
    
    class var meetingsNavigation: UINavigationController {
        return self.rootController(identifier: STORYBOARD_ID.meetingsNavigation) as! RootNavigationController
    }
    
    class var chatNavigation: UINavigationController {
        return self.rootController(identifier: STORYBOARD_ID.chatNavigation) as! RootNavigationController
    }
    
    class var profileNavigation: UINavigationController {
        return self.rootController(identifier: STORYBOARD_ID.profileNavigation) as! RootNavigationController
    }
    
    //MARK: loign NAVIGATION
    
    static var loginNavigation: UINavigationController {
        return self.loginController(identifier: STORYBOARD_ID.loginNavigation) as! UINavigationController
    }
    
    //MARK: Tab bar controller
    
//    static var homeTabbarController : HomeTabbarController {
//        self.rootController(identifier: STORYBOARD_ID.homeTabbarController) as! HomeTabbarController
//    }
//    
//    //MARK: View controllers
//    
//    static var otpVerifyController : OtpVerifyController {
//        self.loginController(identifier: STORYBOARD_ID.otpVerifyController) as! OtpVerifyController
//    }
//    
//    static var signupCompletedController : SignupCompletedController {
//        self.loginController(identifier: STORYBOARD_ID.signupCompletedController) as! SignupCompletedController
//    }
//    
//    static var walkThrew2Controller : WalkThrew2Controller {
//        self.loginController(identifier: STORYBOARD_ID.walkThrew2Controller) as! WalkThrew2Controller
//    }
//    
//    static var mobileSignupController : MobileSignupController {
//        self.loginController(identifier: STORYBOARD_ID.mobileSignupController) as! MobileSignupController
//    }
    
    
    
    
    
}

extension UINavigationController {
    
    func setCustomNavigationBar(title:String, isHidden:Bool) {
        self.isNavigationBarHidden = isHidden
        self.navigationBar.barStyle = .default
//        self.navigationBar.barTintColor = UIColor.navigationColor
//        self.navigationBar.tintColor = UIColor.textColor
        self.navigationBar.isTranslucent = false
        self.navigationBar.topItem?.title = title
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
      //  self.navigationBar.shadowImage = UIImage()
    }
    
    func setTitleImage(image:UIImage) {
        let imageView = UIImageView(image: image)
        
        let bannerWidth = self.navigationBar.frame.size.width
        let bannerHeight = self.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        self.navigationBar.topItem?.titleView = imageView
    }
    
    
    
    
    
}
