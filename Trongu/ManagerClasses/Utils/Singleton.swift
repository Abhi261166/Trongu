//
//  Singleton.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 07/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit
import CoreTelephony
//import AWSCore
//import AWSS3
//import FBSDKLoginKit
//import GoogleSignIn



class Singleton: NSObject {
    
    static let shared = Singleton()
    static var fromMenuNeedHelp:Bool = false
    static var coins:Int? = 0
    //    static var userProfileData:UserProfileData?
    
    var keyboardSize: CGSize = CGSize(width: 0.0, height: 0.0)
    var errorMessageView: ErrorView!
    var callBackFromError: ((Bool?) -> Void)?
    static var isOtherProfile:Bool = false
    //    static var homeTabController: TabBarVC?
    
    
    
    func logoutFromDevice() {
   
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.userDataKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.userIdKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.accessTokenKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.learnReasonKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.spanishLevelKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.dailyGoalKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.learnReasonContinueKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.spanishLevelContinueKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.dailyGoalContinueKey)
        
        UIView.animate(withDuration: 0.3) {
            Singleton.shared.gotoLogin()
        }
    }
    
    func getAppEnv()->String {
#if DEBUG
        return "staging"
#else
        return "live"
#endif
    }
    
    //    //MARK: ERROR MESSAGE
    func showErrorMessage(error: String, isError: ERROR_TYPE) {
        DispatchQueue.main.async {
            guard let window = HEIGHT.window else {return}
            if self.errorMessageView == nil {
                self.errorMessageView = UINib(nibName: NIB_NAME.errorView, bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ErrorView
                self.errorMessageView.delegate = self
                self.errorMessageView.statusIconBgView.isHidden = true
                self.errorMessageView.cornerRadius = 8
                self.errorMessageView.frame = CGRect(x: 10, y: 43, width: SCREEN_SIZE.width-20, height: HEIGHT.errorMessageHeight)
                window.addSubview(self.errorMessageView)
            }
            self.errorMessageView.setErrorMessage(message: error,isError: isError)
        }
    }
    
    func showErrorMessage(pushData: PushModel, isError: ERROR_TYPE, completionHandler:@escaping (_ pushData: Bool?) -> ()) {
        DispatchQueue.main.async {
            let window = HEIGHT.window
            if self.errorMessageView == nil {
                self.errorMessageView = UINib(nibName: NIB_NAME.errorView, bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ErrorView
                self.errorMessageView.statusIcon.isHidden = false
                self.errorMessageView.cornerRadius = 8
                self.errorMessageView.statusIcon.image = #imageLiteral(resourceName: "cancel_notes@2x.png")
                self.errorMessageView.statusIcon.cornerRadius = 3
                self.errorMessageView.statusIcon.clipsToBounds = true
                self.errorMessageView.delegate = self
                self.errorMessageView.pushData = pushData
                self.errorMessageView.callBackFromError = { data in
                    completionHandler(data)
                }
                self.errorMessageView.frame = CGRect(x: 10, y: 43 , width: SCREEN_SIZE.width-20, height: HEIGHT.errorMessageHeight)
                window?.addSubview(self.errorMessageView)
            }
            self.errorMessageView.setErrorMessage(message: pushData.title ?? "", isError: isError)
        }
    }
    
    func translateErrorMessage(toBottom:Bool) {
        if errorMessageView != nil {
            if toBottom == true {
                self.errorMessageView.translateToBottom()
            } else {
                self.errorMessageView.translateToTop()
            }
        }
    }
    
    func gotoLogin(window: UIWindow? = HEIGHT.window) {
        let vc = LoginTypeVC()
        let loginNav = UINavigationController(rootViewController: vc)
        loginNav.navigationBar.isHidden = true
        window?.rootViewController = loginNav
        window?.makeKeyAndVisible()
    }
    
    func setHomeView(window: UIWindow? = HEIGHT.window) {
        
        if let userData = UserDefaultsCustom.getUserData() {
            
            if userData.access_token != ""{
                let vc = TabBarController()
                let navVC = UINavigationController(rootViewController: vc)
                navVC.isNavigationBarHidden = true
                window?.rootViewController = navVC
                window?.frame = UIScreen.main.bounds
                window?.makeKeyAndVisible()
                //                if let learnReason = UserDefaultsCustom.learnReasonContinue, let learn = UserDefaultsCustom.learnReason{
                //
                //                    print("index-- \(learnReason) ----Value-- \(learn)")
                //
                //                    if let spanishLevel = UserDefaultsCustom.spanishLevelContinue, let level = UserDefaultsCustom.spanishLevel{
                //
                //                        print("index-- \(spanishLevel) ----Value-- \(level)")
                //
                //
                //                        if let dailyGoal = UserDefaultsCustom.dailyGoalContinue, let daily = UserDefaultsCustom.dailyGoal{
                //
                //                            print("index-- \(dailyGoal) ----Value-- \(daily)")
                //
                //
                //                            setController(Controller: TabBarController(), window: window)
                //
                //                        }else{
                //
                //                            goToLerningGoal(window: window)
                //
                //                        }
                //
                //                    }else{
                //
                //                        goToSelectSpanishLevel(window: window)
                //
                //                    }
                //
                //                }
                //                else{
                //                    setController(Controller: SelectLearnReasonVC(), window: window)
                //                }
                //
                //            } else{
                //                setTutorVC(window: window)
                //            }
                
            } else {
                let vc = LoginTypeVC()
                let navVC = UINavigationController(rootViewController: vc)
                navVC.isNavigationBarHidden = true
                window?.rootViewController = navVC
                window?.frame = UIScreen.main.bounds
                window?.makeKeyAndVisible()
            }
        }else{
            let vc = LoginTypeVC()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            window?.rootViewController = navVC
            window?.frame = UIScreen.main.bounds
            window?.makeKeyAndVisible()
        }
    }
}

extension Singleton: ErrorDelegate {
    //MARK: ERROR DELEGATE METHOD
    func removeErrorView() {
        if errorMessageView != nil {
            self.errorMessageView.removeFromSuperview()
            self.errorMessageView = nil
        }
    }
}

//extension Singleton{
//    func setController(Controller:UIViewController, window: UIWindow? = HEIGHT.window){
//        let navVC = UINavigationController(rootViewController: Controller)
//        navVC.isNavigationBarHidden = true
//        window?.rootViewController = navVC
//        window?.frame = UIScreen.main.bounds
//        window?.makeKeyAndVisible()
//    }
//
//    func goToLerningGoal(window: UIWindow? = HEIGHT.window){
//        let navVC = UINavigationController(rootViewController: SelectLearnReasonVC())
//        navVC.viewControllers.append(SelectSpanishLevelVC())
//        navVC.viewControllers.append(DailyLearningGoalVC())
//        navVC.isNavigationBarHidden = true
//        window?.rootViewController = navVC
//        window?.frame = UIScreen.main.bounds
//        window?.makeKeyAndVisible()
//    }
//
//    func goToSelectSpanishLevel(window: UIWindow? = HEIGHT.window){
//        let navVC = UINavigationController(rootViewController: SelectLearnReasonVC())
//        navVC.viewControllers.append(SelectSpanishLevelVC())
//        navVC.isNavigationBarHidden = true
//        window?.rootViewController = navVC
//        window?.frame = UIScreen.main.bounds
//        window?.makeKeyAndVisible()
//    }
//
//    func setTutorVC(window: UIWindow? = HEIGHT.window){
//
//      //  let window: UIWindow? = HEIGHT.window
//         let vc = TabBarVC()
//         window?.rootViewController = vc
//         window?.frame = UIScreen.main.bounds
//         window?.makeKeyAndVisible()
//
//
//    }
//
//}
