////
////  GoogleManager.swift
////
////  Created by Nitin Kumar on 06/06/20.
////  Copyright © 2020 Nitin Kumar. All rights reserved.
////
//
//import UIKit
//import GoogleSignIn
//
//typealias googleResponse = (_ userId:String?, _ fullName: String?, _ email : String?, _ idToken : String? , _ profilePicture : URL?) -> ()
//typealias googleFailureResponse = (_ error:String?) -> ()
//
//class GoogleManager: NSObject {
//    
//
//    var viewController:UIViewController?
//    
//    static let shared = GoogleManager()
//    
//    func googleSignIn(controller:UIViewController, success: @escaping googleResponse, failure: @escaping googleFailureResponse){
//        // ActivityIndicator.sharedInstance.showActivityIndicator()
//      
//        viewController = controller
//        let signInConfig = GIDConfiguration.init(clientID: "290108215228-39o31njiohuu1ofansmru9cnrfakeof1.apps.googleusercontent.com")
//        
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: controller) { user, error in
//            guard error == nil else {
//                failure(error?.localizedDescription ?? "")
//                return }
//            print("profile pictue url \(user?.profile?.imageURL(withDimension: 400)?.absoluteString ?? "not found")")
//            success(user?.userID, user?.profile?.name, user?.profile?.email, user?.authentication.idToken, user?.profile?.imageURL(withDimension: 500))
//            // If sign in succeeded, display the app's main content View.
//          }
//    }
//    
//    
//}
