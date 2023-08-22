//
//  AppDelegate.swift
//  Trongu
//
//  Created by apple on 26/06/23.
//

import UIKit
import IQKeyboardManager
import FirebaseCore
import FirebaseAuth
import FBSDKCoreKit
import GoogleSignIn
//import GooglePlaces
import GoogleMaps



@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let splash = LoginTypeVC()
        let navController = UINavigationController(rootViewController: splash)
        navController.navigationBar.isHidden = true
        window?.rootViewController = splash
        window?.makeKeyAndVisible()
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        GMSServices.provideAPIKey("AIzaSyAfI25bSC3rD6gteJIHFCZ7vBCglGl6OkE")
     //   GMSPlacesClient.provideAPIKey("AIzaSyAfI25bSC3rD6gteJIHFCZ7vBCglGl6OkE")
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        ApplicationDelegate.shared.application(
//                   app,
//                   open: url,
//                   sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                   annotation: options[UIApplication.OpenURLOptionsKey.annotation])
      return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.reduce("") { $0 + String(format: "%02.2hhx", $1) }
        print("registered for notifications", token)
        UserDefaultsCustom.deviceToken = token

    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

