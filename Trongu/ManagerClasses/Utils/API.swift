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

class API {
    static let deviceType = "2"
    static let version    = "1.0"
    static let host       = "http://161.97.132.85/"
    static let appName    = "Trongu"
    

    
    static let termAndConditions = "http://161.97.132.85/TermsAndConditions.html"
    static let aboutlink = "http://161.97.132.85/Aboutus.html"
    static let privacyPolicy = "http://161.97.132.85/PrivacyPolicylink.html"
    static let imageUrl = "http://161.97.132.85/j1/finder/user_images/"

    
    enum DataKey: String {
        case dataKey = "pic"
    }
    
    struct Name {
        // MARK: LOGIN AND SOCIAL LOGIN CONSTANT API
        static let login                  = "j1/trongu/api/v1/users/login"
        static let signup                 = "j1/trongu/api/v1/users/signup"
        static let forgotPassword         = "j1/trongu/api/v1/users/forgotpassword"
        static let logout                 = "j1/trongu/api/v1/users/logout"
        static let googleLogin            = "j1/trongu/api/v1/users/googlelogin"
        static let fbLogin                = "j1/trongu/api/v1/users/facebooklogin"
        static let appleLogin             = "j1/trongu/api/v1/users/applelogin"
        static let socialLogin            = "j1/trongu/api/v1/users/sociallogin"
        static let changePass             = "j1/trongu/api/v1/users/change-password"
        static let editProfile            = "j1/trongu/api/v1/users/editprofile"
        static let getProfile             = "j1/trongu/api/v1/users/get-profile"
        static let deleteAcount           = "j1/trongu/api/v1/users/del"
        
        // create post
        static let tagList                = "j1/trongu/api/v1/users/followers-following-with-type"
        static let postList               = "j1/trongu/api/v1/users/home-listing"
        static let deletePost             = "j1/trongu/api/v1/users/post-del"
        static let likePost               = "j1/trongu/api/v1/users/add-like-post"
        static let commentList            = "j1/trongu/api/v1/users/comment-listing"
        static let addcomment             = "j1/trongu/api/v1/users/add-reply-comment"
        static let profilePostDetails     = "j1/trongu/api/v1/users/get-user-details"
        static let likesList              = "j1/trongu/api/v1/users/post-like"
        static let searchLikesList        = "j1/trongu/api/v1/users/search-post-like-with-name-user-name"
        
        
        // search Apis
        
      //  static let search                 = "j1/trongu/api/v1/users/search-names-with-type"
        static let search                 = "j1/trongu/api/v1/users/recet-search-listing"
        static let addToRecent            = "j1/trongu/api/v1/users/add-recent-search"
        static let deleteFromRecent       = "j1/trongu/api/v1/users/recent-search-del"
        
        // Setting Api
        static let accountType            = "j1/trongu/api/v1/users/user-public-private"
    
        // other user profile
        static let follow                 = "j1/trongu/api/v1/users/follow-unfollow"
        static let getFollowFollowingList = "j1/trongu/api/v1/users/followers-following-listing"
        static let addToBucket            = "j1/trongu/api/v1/users/add-bucket"
        static let postFilter             = "j1/trongu/api/v1/users/filter-post"
        static let bucketListing          = "j1/trongu/api/v1/users/bucket-listing"
        static let blockUser              = "j1/trongu/api/v1/users/add-block-users"
        static let blockUserListing       = "j1/trongu/api/v1/users/block-listing"
        static let reportUser             = "j1/trongu/api/v1/users/add-report-users"
        static let reportPost             = "j1/trongu/api/v1/users/add-report-post"
        static let removeFollower         = "j1/trongu/api/v1/users/remove-follower"
        static let profileMap             = "j1/trongu/api/v1/users/profile-map"
        
        // notifications
        static let getNotificationListing = "j1/trongu/api/v1/users/notification-listing"
        static let acceptRejectFollowRequest = "j1/trongu/api/v1/users/accept-reject-request"
        static let notificationCountUpdate  = "j1/trongu/api/v1/users/updateseennotification"
    
        // post details
        static let getPostDetails         = "j1/trongu/api/v1/users/get-post-detail"
        
        // Chat Apis
        static let createRoom             = "j1/trongu/api/v1/users/create-room"
        static let getAllChatUsers        = "j1/trongu/api/v1/users/get-all-chat-users"
        static let getAllChat             = "j1/trongu/api/v1/users/get-all-chat-message"
        static let sendMessage            = "j1/trongu/api/v1/users/send-message"
        static let updateSeen             = "j1/trongu/api/v1/users/update-chat-status"
        static let feedBackTypes          = "j1/trongu/api/v1/users/feedbacklisting"
        static let SendFeedBack           = "j1/trongu/api/v1/users/feedbacksubmit"
        
        // categorys
        
        static let getCategories          = "j1/trongu/api/v1/users/post-categories-dropdown"
        static let updateOnlineStatus     = "j1/trongu/api/v1/users/check-online-status"
        
        
        
        
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
        static let EMAIL_NOT_Verified       = 402
        static let Invalid_Cred             = 403
        static let Account_Disabled         = 405
        static let SHOW_MESSAGE             = 201
        static let SHOW_DATA                = 200
        static let SLOW_INTERNET_CONNECTION = 999
    }
    
}

struct AlertMessage {
    static let INVALID_ACCESS_TOKEN        = "Your session is expired. we will logout your session from this device."
    static let Email_Veryfication          = "Your email is not verified, please check email and verify."
    static let invalid_Credencials         = "Please enter valid credentials."
    static let account_desabled            = "Your  account is disable by admin .Please contact admin for more details"
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
