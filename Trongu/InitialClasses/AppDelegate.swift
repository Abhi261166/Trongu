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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setNotification(application)
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
    
    
    
    
    func setNotification(_ application: UIApplication) {
//         For iOS 10 display notification (sent via APNS)
//        guard UserDefaultsCustom.firstTimeOpen == false else { return }
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _  in
                print("notificaiton allowed")
            })
//        UserDefaults.standard.setValue(nil, forKey: UserDefaultsCustom.)
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }
    
   
    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        print("share profile url---",url)
        
//        ApplicationDelegate.shared.application(
//                   app,
//                   open: url,
//                   sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                   annotation: options[UIApplication.OpenURLOptionsKey.annotation])
      return GIDSignIn.sharedInstance.handle(url)
    }

//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//        let token = deviceToken.reduce("") { $0 + String(format: "%02.2hhx", $1) }
//        print("registered for notifications", token)
//        UserDefaultsCustom.deviceToken = token
//
//    }
//
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

            print("registered for notifications", token)
            UserDefaultsCustom.deviceToken = token
            print("UserDefaultsCustom.deviceToken = \(UserDefaultsCustom.deviceToken)")
            
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
    
    
    //MARK: Background push notification Receive
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let dict = userInfo as? [String:Any] {
            print("Background push notification \(dict)")
        }
        completionHandler()
    }

    //MARK: - Forground push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.banner,.list,.sound])

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let dict = userInfo as? JSON  else { return }

//        let pushModel = PushModel(json: dict)
//        if pushModel.pushType == .like || pushModel.pushType == .comment_post {
//            NotificationCenter.default.post(name: .updatePost, object: pushModel)
//        }
        print("Default push notification \(dict)")
//        UserDefaults.setValue(value: dict, for: "message recieved \(pushModel.pushType?.rawValue ?? 0)")
//        let interval = UIApplication.backgroundFetchIntervalMinimum
//        UIApplication.shared.setMinimumBackgroundFetchInterval(interval)
        
        completionHandler(.newData)
    }

}

