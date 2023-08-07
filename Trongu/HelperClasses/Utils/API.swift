//
//  API.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 03/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit


//const val TERMS_CONDITIONS = "http://161.97.132.85/CloutLyfe/TermsAndConditions.html"
//const val PRIVACY_POLICY   = "http://161.97.132.85/CloutLyfe/Privacy-Policy.html"
//http://161.97.132.85/j1/trongu/api/v1/users/signup
class API {
    static let deviceType = "2"
    static let version    = "1.0"
    static let host       = "http://161.97.132.85/"
    static let appName       = "Trongu"
    

    
    static let termAndConditions = "http://161.97.132.85/TermsAndConditions.html"
    static let aboutlink = "http://161.97.132.85/Aboutus.html"
    static let privacyPolicy = "http://161.97.132.85/PrivacyPolicylink.html"
    static let imageUrl = "http://161.97.132.85/j1/finder/user_images/"

    
    enum DataKey: String {
        case dataKey = "pic"
    }
    
    struct Name {
        // MARK: LOGIN AND SOCIAL LOGIN CONSTANT API
        static let login                  = "gospeak/api/v1/user/login"
        static let signup                 = "j1/trongu/api/v1/users/signup"
        static let forgotPassword         = "gospeak/api/v1/user/forgotpassword"
        static let logout                 = "gospeak/api/v1/user/logout"
        static let changePass             = "gospeak/api/v1/user/changepassword"
        static let onboarding             = "gospeak/api/v1/user/onboarding"
        static let phoneSignup            = "gospeak/api/v1/user/phonesignup"
        static let appleLogIn             = "gospeak/api/v1/user/applelogin"
        static let deleteAccount          = "gospeak/api/v1/user/deleteaccount"
        static let getProfile             = "gospeak/api/v1/user/profile"
        static let categoryList           = "gospeak/api/v1/category/categorylist"
        static let subCategoryList        = "gospeak/api/v1/subcategory/subcategorylist"
        static let editProfile            = "gospeak/api/v1/user/editprofile"
        static let changeVoice            = "gospeak/api/v1/user/changevoice"
        static let saveChat               = "gospeak/api/v1/chatbot/savechat"
        static let savedChatList          = "gospeak/api/v1/chatbot/allconversation"
        static let savedChatDetails       = "gospeak/api/v1/chatbot/getallchat?room_no="
        static let deleteSavedChat        = "gospeak/api/v1/chatbot/deletechat?room_no="
        
    }
    
    struct keys {
        static let access_token = "access_token"
        static let country_code = "country_code"
        static let phone_no     = "phone_no"
        static let otp          = "otp"
        static let device_type  = "device_type"
        static let device_token = "device_token"
    }
    
    enum HttpMethod: String {
        case POST   = "POST"
        case GET    = "GET"
        case PUT    = "PUT"
        case DELETE = "DELETE"
    }
    
//    struct statusCodes {
//        static let INVALID_ACCESS_TOKEN = 401
//        static let BAD_REQUEST = 400
//        static let UNAUTHORIZED_ACCESS = 401
//        static let SHOW_MESSAGE = 201
//        static let SHOW_DATA = 200
//        static let SLOW_INTERNET_CONNECTION = 999
//    }
    
    struct statusCodes {
        static let INVALID_ACCESS_TOKEN     = 2
        static let BAD_REQUEST              = 400
        static let UNAUTHORIZED_ACCESS      = 401
        static let SHOW_MESSAGE             = 201
        static let SHOW_DATA                = 200
        static let SLOW_INTERNET_CONNECTION = 999
    }
    
}

struct AlertMessage {
    static let INVALID_ACCESS_TOKEN        = "Product is being used on another device"
    static let SERVER_NOT_RESPONDING       = "Something went wrong while connecting to server!"
    static let NO_INTERNET_CONNECTION      = "Unable to connect with the server. Check your internet connection and try again."
    static let pleaseEnter                 = "Please enter "
    static let invalidEmailId              = "Please enter valid email id."
    static let enterEmailId                = "Please enter email id."
    static let invalidPassword             = "Please enter correct password."
    static let invalidPhoneNumber          = "Please enter valid phone."
    static let invalidPasswordLength       = "Password must contain atleast 6 characters"
    static let logoutAlert                 = "Are you sure you want to logout?"
    static let imageWarning                = "The image we have showed above is for reference purpose. Actual car could be slightly different."
    static let emptyMessage                = " can not be empty."
    static let bookingCreated              = "Booking created successfully"
    static let passwordMismatch            = "New password and confirm password does not match."
    static let passwordChangedSuccessfully = "Password changed successfully."
    static let pleaseEnterValid            = "Please enter valid "
    static let transactionSuccessful       = "Your transaction was successful"
    static let PROFILE_SAVED               = "Profile has been saved successfully"
}

struct ERROR_MESSAGE {
    static let NO_CAMERA_SUPPORT           = "This device does not support camera"
    static let NO_GALLERY_SUPPORT          = "Photo library not found in this device."
    static let REJECTED_CAMERA_SUPPORT     = "Need permission to open camera"
    static let REJECTED_GALLERY_ACCESS     = "Need permission to open Gallery"
    static let SOMETHING_WRONG             = "Something went wrong. Please try again."
    static let NO_INTERNET_CONNECTION      = "Unable to connect with the server. Check your internet connection and try again."
    static let SERVER_NOT_RESPONDING       = "Something went wrong while connecting to server!"
    static let INVALID_ACCESS_TOKEN        = "Invalid Access Token"
    static let ALL_FIELDS_MANDATORY        = "All Fields Mandatory"
    static let CALLING_NOT_AVAILABLE       = "Calling facility not available on this device."
}
