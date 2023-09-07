//
//  SignUpVM.swift
//  Trongu
//
//  Created by dr mac on 19/07/23.
//

import Foundation
import UIKit
protocol SignUpVMObserver: NSObjectProtocol {
    func observeSignUpSucessfull()
}
class SignUpVM: NSObject {
    
    var observer: SignUpVMObserver?
    var editImage: PickerData?
    var imagePicker = GetImageFromPicker()
    var edit_cover_Image: PickerData?
    
    
    init(observer: SignUpVMObserver?) {
        self.observer = observer
    }
//    func validateSignUpDetails(username:String,name:String,email: String, password: String,terms: Bool) -> Bool {
//        let isvalidUsername = Validator.validateName(name: name)
//        let isvalidEmail = Validator.validateEmail(candidate: email)
//        let isValidPassword = Validator.validateOldPassword(password: password)
//        
//        guard isvalidUsername.0 == true else {
//            Singleton.showMessage(message: "\(isvalidUsername.1)", isError: .error)
//            print("isvalidUsername  \(isvalidUsername)")
//            return false
//        }
//        guard isvalidEmail.0 == true else {
//            Singleton.showMessage(message: "\(isvalidEmail.1)", isError: .error)
//            print("isvalidEmail  \(isvalidEmail)")
//            return false
//        }
//        guard isValidPassword.0 == true else {
//            Singleton.showMessage(message: "\(isValidPassword.1)", isError: .error)
//            print("isValidPassword  \(isValidPassword)")
//            return false
//        }
//        
//        guard terms == true else {
//            Singleton.showMessage(message: "Please accept terms and conditions", isError: .error)
//            return false
//        }
//        return true
//    }
    func apiSignup(name:String,email:String,pswrd:String,place:String,birthDate:String,gender:String,ethnicity:String,
                   lat :String, long:String,username:String,bio:String){
        var params = JSON()
        params["user_name"] = username
        params["name"] = name
        params["email"] = email
        params["password"] = pswrd
        params["device_type"] = "2"
        params["place"] = place
        params["dob"] = birthDate
        params["gender"] = gender
        params["ethnicity"] = ethnicity
        params["device_token"] = UserDefaultsCustom.deviceToken
        params["lat"] = lat
        params["long"] = long
        params["login_type"] = "1"
        params["bio"] = bio
        print(params,"Okkk")
        AppDefaults.password = pswrd
        
        
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.updateProfile(apiName: API.Name.signup, params: params, profilePhoto: editImage) { succeeded, response, data in
    ActivityIndicator.shared.hideActivityIndicator()
            DispatchQueue.main.async {
                print("api responce in Home screen : \(response)")
                if succeeded == true {
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .success)
                    }
                    self.observer?.observeSignUpSucessfull()
                } else {
                    self.showMessage(message: response["message"] as? String ?? "" , isError: .error)
                }
            }
  
        }
        
        
        
//        ActivityIndicator.shared.showActivityIndicator()
//        ApiHandler.callWithMultipartForm(apiName: API.Name.signup, params: params) { [weak self] succeeded, response, data in
//            DispatchQueue.main.async {
//                ActivityIndicator.shared.hideActivityIndicator()
//                if let self = self{
//                    if succeeded == true, let data{
//                        let decoder = JSONDecoder()
////                        if let message = response["message"] as? String {
////                            self.showMessage(message: message, isError: .success)
////                        }
//                        if let message = response["message"] as? String {
//                            self.showMessage(message: message, isError: .success)
//                        }
//
//
//                            self.observer?.observeSignUpSucessfull()
////                        }catch{
////                            print("error",error)
////                        }
//                    }else{
//                        if let message = response["message"] as? String {
//                            self.showMessage(message: message, isError: .error)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    
    func fbSignup(name:String,email:String,pswrd:String,place:String,birthDate:String,gender:String,ethnicity:String,
                      lat :String, long:String,username:String,fbId:String){
        var params = JSON()
        params["user_name"] = username
        params["name"] = name
        params["email"] = email
//        params["password"] = pswrd
        params["device_type"] = "2"
        params["place"] = place
        params["dob"] = birthDate
        params["gender"] = gender
        params["ethnicity"] = ethnicity
        params["device_token"] = UserDefaultsCustom.deviceToken
        params["lat"] = lat
        params["long"] = long
        params["login_type"] = 0
        params["facebook_id"] = fbId
        print(params,"Okkk")
        AppDefaults.password = pswrd
        
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.fbLogin, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                   if let self = self{
                    if succeeded == true, let data{
                        let decoder = JSONDecoder()

                            if let message = response["message"] as? String {
                                self.showMessage(message: message, isError: .success)
                                
                                do {
                                    let decoded = try decoder.decode(UserModel.self, from: data)
                                    if let userData = decoded.data {
                                        UserDefaultsCustom.saveUserData(userData: userData)
                                        UserDefaultsCustom.userId = userData.id
                                        UserDefaultsCustom.authToken = userData.access_token
                                        DefaultManager.shared.isNew = "yes"
                                        if let message = response["message"] as? String {
                                            self.showMessage(message: message, isError: .success)
                                        }
                                        self.observer?.observeSignUpSucessfull()
                                    }
                                    
                                } catch {
                                    print("error", error)
                                }
                            }
                    }else{
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
    }
    
    func appleSignUp(name:String,email:String,pswrd:String,place:String,birthDate:String,gender:String,ethnicity:String,
                      lat :String, long:String,username:String,appleId:String){
        var params = JSON()
        params["user_name"] = username
        params["name"] = name
//        params["email"] = email
//        params["password"] = pswrd
//        params["device_type"] = "2"
        params["place"] = place
        params["dob"] = birthDate
        params["gender"] = gender
        params["ethnicity"] = ethnicity
//        params["device_token"] = UserDefaultsCustom.deviceToken
        params["lat"] = lat
        params["long"] = long
//        params["login_type"] = 0
//        params["apple_id"] = appleId
        print(params,"Okkk")
        AppDefaults.password = pswrd
        
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.socialLogin, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                   if let self = self{
                    if succeeded == true, let data{
                        let decoder = JSONDecoder()

                            if let message = response["message"] as? String {
                                self.showMessage(message: message, isError: .success)
                                
                                do {
                                    let decoded = try decoder.decode(UserModel.self, from: data)
                                    if let userData = decoded.data {
                                        UserDefaultsCustom.saveUserData(userData: userData)
                                        UserDefaultsCustom.userId = userData.id
                                        UserDefaultsCustom.authToken = userData.access_token
                                        DefaultManager.shared.isNew = "yes"
                                        if let message = response["message"] as? String {
                                            self.showMessage(message: message, isError: .success)
                                        }
                                        self.observer?.observeSignUpSucessfull()
                                    }
                                    
                                } catch {
                                    print("error", error)
                                }
                            }
                    }else{
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
    }
    
    func googleSignup(name:String,email:String,pswrd:String,place:String,birthDate:String,gender:String,ethnicity:String,
                      lat :String, long:String,username:String,googleId:String,bio:String){
        var params = JSON()
        params["user_name"] = username
        params["name"] = name
//        params["email"] = email
//        params["password"] = pswrd
//        params["device_type"] = "2"
        params["place"] = place
        params["dob"] = birthDate
        params["gender"] = gender
        params["ethnicity"] = ethnicity
//        params["device_token"] = UserDefaultsCustom.deviceToken
        params["lat"] = lat
        params["long"] = long
        params["bio"] = bio
//        params["login_type"] = 0
//        params["google_id"] = googleId
//        params["facebook_id"] = "0"
//        params["apple_id"] = "0"
        print(params,"Okkk")
        AppDefaults.password = pswrd
        
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.updateProfile(apiName: API.Name.socialLogin, params: params, profilePhoto: editImage) { succeeded, response, data in
    ActivityIndicator.shared.hideActivityIndicator()
            DispatchQueue.main.async {
                print("api responce in Home screen : \(response)")
                if succeeded == true, let data {
                    let decoder = JSONDecoder()
                    
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .success)
                    }
                    
                    do {
                        let decoded = try decoder.decode(UserModel.self, from: data)
                        if let userData = decoded.data {
                            UserDefaultsCustom.saveUserData(userData: userData)
                            UserDefaultsCustom.userId = userData.id
                            UserDefaultsCustom.authToken = userData.access_token
                            DefaultManager.shared.isNew = "yes"
                            if let message = response["message"] as? String {
                                self.showMessage(message: message, isError: .success)
                            }
                            self.observer?.observeSignUpSucessfull()
                        }
                        
                    } catch {
                        print("error", error)
                    }
                    
                    
                } else {
                    self.showMessage(message: response["message"] as? String ?? "" , isError: .error)
                }
            }
  
        }
        
  //      ActivityIndicator.shared.showActivityIndicator()
  //      ApiHandler.callWithMultipartForm(apiName: API.Name.socialLogin, params: params) { [weak self] succeeded, response, data in
//            DispatchQueue.main.async {
//                ActivityIndicator.shared.hideActivityIndicator()
//                   if let self = self{
//                    if succeeded == true, let data{
//                        let decoder = JSONDecoder()
//
//                            if let message = response["message"] as? String {
//                                self.showMessage(message: message, isError: .success)
//
//                                do {
//                                    let decoded = try decoder.decode(UserModel.self, from: data)
//                                    if let userData = decoded.data {
//                                        UserDefaultsCustom.saveUserData(userData: userData)
//                                        UserDefaultsCustom.userId = userData.id
//                                        UserDefaultsCustom.authToken = userData.access_token
//                                        DefaultManager.shared.isNew = "yes"
//                                        if let message = response["message"] as? String {
//                                            self.showMessage(message: message, isError: .success)
//                                        }
//                                        self.observer?.observeSignUpSucessfull()
//                                    }
//
//                                } catch {
//                                    print("error", error)
//                                }
//                            }
//                    }else{
//                        if let message = response["message"] as? String {
//                            self.showMessage(message: message, isError: .error)
//                        }
//                    }
//                }
//            }
   //     }
    }
}
extension NSObject {
    
    func showMessage(message:String, isError:ERROR_TYPE) {
        Singleton.shared.showErrorMessage(error: message, isError: isError)
    }
    static func showMessage(message:String, isError:ERROR_TYPE) {
        Singleton.shared.showErrorMessage(error: message, isError: isError)
    }
    
//    var window: UIWindow? {
//        return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
//    }
    
//    static var window: UIWindow? {
//        return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
//    }
}
