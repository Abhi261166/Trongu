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
        onlineOfflineApiCall(isOnline: 1)
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
        
      return GIDSignIn.sharedInstance.handle(url)
        
    }


    
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
            let pushData = PushModel(json: dict)
            self.handleTap(_onBackgroundController: pushData)
        }
        completionHandler()
    }

    //MARK: - Forground push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        

        let userInfo = notification.request.content.userInfo
        if let dict = userInfo as? [String:Any] {
            
            print("Background push notification \(dict)")
            let pushData = PushModel(json: dict)
            
            
            
            if UIApplication.shared.topViewController() is ChatVC {
                print("do not show push")
                       completionHandler([])
            } else {
                print("show push")
                completionHandler([.badge,.banner,.list,.sound])
                if pushData.pushType == .Message {
                    NotificationCenter.default.post(name: .init("updateChatList"), object: nil)
                    let vc = UIWindow.visibleViewController
                    
                    if let controller = vc as? ChatVC {
                        if controller.viewModel?.roomId == pushData.room_id {
                            return
                        }
                    }
                }
                
                if pushData.pushType == .like || pushData.pushType == .comment_post {
                    //NotificationCenter.default.post(name: .updatePost, object: pushData)
                }
                
                Singleton.shared.showErrorMessage(pushData: pushData, isError: .notification) { data in
                    DispatchQueue.main.async {
                        print("pushData.message :-  \(pushData.message)")
                        self.handleTap(_onForgroundNotification: pushData)
                    }
                }
                completionHandler([])
                
            }
            
        }
        
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
    
    func redirectToSingleChat(pushData: PushModel, vc: UIViewController?){
            print("visibleViewController :- \(vc)")
          
        if UserDefaultsCustom.getUserData()?.id == pushData.user_id{
            
            let chat = ChatVC(roomId: pushData.room_id ?? "", otherUserName: pushData.username ?? "", otherUserId: pushData.otherID ?? "", otherUserProfileImage: "")
            
            print("push data",pushData.room_id ?? "" )
            vc?.pushViewController(chat , true)
            
        }else{
            let chat = ChatVC(roomId: pushData.room_id ?? "", otherUserName: pushData.username ?? "", otherUserId: pushData.user_id ?? "", otherUserProfileImage: "")
            
            print("push data",pushData.room_id ?? "" )
            vc?.pushViewController(chat , true)
            
        }
       
    }
    
    
    //MARK: Forground push notification handle
    func handleTap(_onForgroundNotification pushData: PushModel) {
        let viewController = UIWindow.visibleViewController
        switch pushData.pushType {
        case .like:
            let vc = DetailVC()
            vc.postId = pushData.post_id
            vc.comeFrom = "Push"
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .comment_post:
            let vc = DetailVC()
            vc.comeFrom = "Push"
            vc.postId = pushData.post_id
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .following:
            let vc = NotificationVC()
            vc.comeFrom = "notification"
            vc.completion = { }
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .followRequest:
            let vc = NotificationVC()
            vc.comeFrom = "notification"
            vc.completion = { }
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .Message:
            redirectToSingleChat(pushData: pushData, vc: viewController)
        default: break
        }
    }
    
    //MARK: Background push notification
    func handleTap(_onBackgroundController pushData: PushModel) {
        let viewController = UIWindow.visibleViewController
        switch pushData.pushType {
        case .like:
            let vc = DetailVC()
            vc.comeFrom = "Push"
            vc.postId = pushData.post_id
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .comment_post:
            let vc = DetailVC()
            vc.comeFrom = "Push"
            vc.postId = pushData.post_id
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .following:
            let vc = NotificationVC()
            vc.comeFrom = "notification"
            vc.completion = { }
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .followRequest:
            let vc = NotificationVC()
            vc.comeFrom = "notification"
            vc.completion = { }
            vc.hidesBottomBarWhenPushed = true
            viewController?.pushViewController(vc, true)
        case .Message:
            redirectToSingleChat(pushData: pushData, vc: viewController)
        default: break
        }
    }

    func onlineOfflineApiCall(isOnline:Int){
            
            var params = JSON()
            params["is_online"] = isOnline
            print("params : ", params)
            
            ApiHandler.callWithMultipartForm(apiName: API.Name.updateOnlineStatus, params: params) { succeeded, response, data in
                DispatchQueue.main.async {
                    if succeeded == true{
                        if isOnline == 1{
                            print("User is online")
                        }else{
                            print("User is offline")
                        }
                    }
                }
            }
    }
}


extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    public static var visibleViewController: UIViewController? {
        let rootViewController = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController
        return UIWindow.visibleViewController(from: rootViewController)
    }

    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)

        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)

        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)

        default:
            return viewController
        }
    }
}

extension UIApplication {
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        switch (base) {
        case let controller as UINavigationController:
            return topViewController(controller.visibleViewController)
        case let controller as UITabBarController:
            return controller.selectedViewController.flatMap { topViewController($0) } ?? base
        default:
            return base?.presentedViewController.flatMap { topViewController($0) } ?? base
        }
    }
}
