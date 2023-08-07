//
//  UserDefaultsCustom.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 04/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit
//import FirebaseMessaging
//import FirebaseCore

struct UserDefaultsCustom {
    static let userDataKey = "userData"
    static let deviceTokenKey = "deviceToken"
    static let userIdKey = "userId"
    static var accessTokenKey = "auth_token"
    static var learnReasonKey = "learnReason"
    static var spanishLevelKey = "spanishLevel"
    static var dailyGoalKey = "dailyGoal"
    static var learnReasonContinueKey = "learnReasonContinue"
    static var spanishLevelContinueKey = "spanishLevelContinue"
    static var dailyGoalContinueKey = "dailyGoalContinue"
    
    
    
    static var deviceToken: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.deviceTokenKey) ?? "device_token"
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.deviceTokenKey)
        }
    }
    
    static var authToken: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.accessTokenKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.accessTokenKey)
        }
    }
    
    static var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.userIdKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.userIdKey)
        }
    }
    
//MARK: Onboarding user defaults
    
    
    static var learnReason: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.learnReasonKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.learnReasonKey)
        }
    }
    
    static var spanishLevel: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.spanishLevelKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.spanishLevelKey)
        }
    }
    
    static var dailyGoal: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.dailyGoalKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.dailyGoalKey)
        }
    }
    
    // Continue Defaults
    
    static var learnReasonContinue: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.learnReasonContinueKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.learnReasonContinueKey)
        }
    }
    
    static var spanishLevelContinue: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.spanishLevelContinueKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.spanishLevelContinueKey)
        }
    }
    
    static var dailyGoalContinue: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCustom.dailyGoalContinueKey)
        } set {
            return UserDefaults.standard.setValue(newValue, forKey: UserDefaultsCustom.dailyGoalContinueKey)
        }
    }
    
    
//    MARK: - SAVE AND GET USER DATA
    static func saveUserData(userData: UserData) {
        print("save user data")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(userData), forKey: UserDefaultsCustom.userDataKey)
    }
    
    static func getUserData() -> UserData? {
        if let data = UserDefaults.standard.value(forKey: UserDefaultsCustom.userDataKey) as? Data {
            let userData = try? PropertyListDecoder().decode(UserData.self, from: data)

            return userData
        }
        return nil
    }
    
}


extension UserDefaults {
    
    class func setValue(value: Any?, for key:String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    class func valueFor(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
}
