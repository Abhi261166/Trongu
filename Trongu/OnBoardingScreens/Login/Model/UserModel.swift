//
//  UserModel.swift
//  Trongu
//
//  Created by dr mac on 19/07/23.
//

import Foundation

class UserModel: Codable {
    var status: Int?
    var message: String?
    var data: UserData?
}

class UserData: Codable  {
    var user_id: String?
    var user_status: Int?
    var email: String?
    var name: String?
    var user_name:String?
    var password: String?
    var phone: String?
    var access_token: String?
    var password_reset_token: String?
    var auth_key: String?
    var verification_token: String?
    var created_at: String?
    var updated_at: String?
    var device_type: String?
    var device_token: String?
    var purpose: String?
    var level: String?
    var voice_type: String?
    var login_type: String?
    var dob:String?
    var ethnicity: String?
    var expireAt: String?
    var id, google_id, facebook_id: String?
    var gender: String?
    var image:String?
    var lat:String?
    var long:String?
    var mail_status:String?
    var place:String?
    var sms_status:String?
    var status:String?
    var bio:String?
    var expire_at:String?
    var posts:String?
    var Following:String?
    var Followers:String?
    var apple_id:String?
    var is_status:String?
    var is_follow:String?
    var is_private:String?
    
}
