//
//  LoginTypeVC.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit
import GoogleSignIn
import Firebase
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit
class LoginTypeVC: UIViewController {
    
    var email = String()
    var name = String()
    var googleToken = String()
    var fbtoken = String()
    var appleToken = String()
    
    var viewModel: LoginTypeVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.navigationController?.isNavigationBarHidden = true
    }
    func setViewModel() {
        self.viewModel = LoginTypeVM(observer: self)
    }
    func googleLoginn(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                // ...
                print("Error Data")
                return
            }
            googleToken = result?.user.userID ?? ""
            name = result?.user.profile?.name ?? ""
            self.email = result?.user.profile?.email ?? ""
            guard let user = result?.user,
                  var idToken = user.userID,
                  var email = user.profile?.email,
                  var fullName = user.profile?.name,
                  var givenName = user.profile?.givenName
                    
                    
            else {
                // ...
                print("Result Data")
                
                return
            }
            print(idToken,"Token")
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            viewModel?.apiGoogleStatus(email: email,googleID: googleToken)

//            let vc = SignUpVC()
//            print(fullName,email, "@#@#!@!##@!")
//            print(idToken,"Token")
//            UserDefaults.standard.set(email, forKey: "email")
//            UserDefaults.standard.set(fullName, forKey: "fullName")
//            vc.name = fullName
//            vc.email = email
//            vc.comeFrom = true
//            vc.googleId = idToken
//            //            vc.family = givenName
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func appleLogin(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        //authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func fbLogin(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            Profile.loadCurrentProfile { (profile, error) in
                print("12345678 \(error) *** ")
                let imageUrl = Profile.current?.imageURL(forMode: .normal, size: CGSize(width: 500, height: 500))?.absoluteString
                self?.fbtoken = Profile.current?.userID ?? ""
                let fbToken = Profile.current?.userID ?? ""
                let fbName = Profile.current?.name ?? ""
                //                  let fbEmail = Profile.current.g
                UserDefaultsCustom.fbToken = fbToken
                UserDefaultsCustom.profilePic = imageUrl
                let vc = SignUpVC()
                
                UserDefaults.standard.set(fbName, forKey: "fbName")
                vc.name = fbName
                //                  vc.email = email
                vc.comeFrom = true
                vc.fbId = fbToken
                //            vc.family = givenName
                self?.navigationController?.pushViewController(vc, animated: true)
                
                //                  self?.viewModel?.setGoogleLoginApi(name: Profile.current?.name ?? "", emai: "", googleId: Profile.current?.userID ?? "", deiceType: API.deviceType, profilePicture: imageUrl, type: "3")
            }
        }
    }
    
    @IBAction func continueWithEmailAction(_ sender: UIButton) {
        appleLogin()
    }
    
    @IBAction func continueWithFacebookAction(_ sender: UIButton) {
        fbLogin()
    }
    
    @IBAction func continueWithGoogleAction(_ sender: UIButton) {
        googleLoginn()
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension LoginTypeVC : ASAuthorizationControllerDelegate{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Handle user authentication
            let appleID = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.givenName
            let email = appleIDCredential.email
            let appleUserFirstName = appleIDCredential.fullName?.givenName ?? ""
            let appleUserLastName = appleIDCredential.fullName?.familyName ?? ""
            let appleUserEmail = appleIDCredential.email ?? ""
            self.appleToken = appleIDCredential.user
            self.email = appleIDCredential.email ?? ""
            let name = "\(appleUserFirstName) \(appleUserLastName)"
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(fullName, forKey: "fullName")
            print(appleID, "@!@##@!#@$")
            print(appleIDCredential.fullName, "@!@Name#@!#@$")
            print(appleIDCredential.email ?? "", "@!@email#@!#@$")
            viewModel?.apiAppleStatus(email: self.email ?? "", appleId: appleToken)

        }
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle authorization error
        print("Apple Sign-In Error: \(error.localizedDescription)")
    }
    
}

extension LoginTypeVC :LoginTypeVMObserver{
    func oberseveFBTypeSuccessfull() {
        print("sdff")
    }
    
    func oberseveAppleTypeSuccessfull() {
        print(UserDefaultsCustom.getUserData()?.is_status ,"Stadhsjhjadshjads")
        if UserDefaultsCustom.getUserData()?.is_status == "1" {
            let vc = TabBarController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = SignUpVC()
            vc.name = name
            vc.name = name ?? ""
            vc.email = email ?? ""
            vc.appleID = appleToken ?? ""
            vc.comeFrom = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func observeLoginTypeSucessfull(){
        if UserDefaultsCustom.getUserData()?.is_status == "1" {
            let vc = TabBarController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = SignUpVC()
            vc.name = name
            vc.email = email
            vc.comeFrom = true
            vc.googleId = googleToken
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
