//
//  User.swift
//  ScannerProject
//
//  Created by Hitexa on 14/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import Foundation
class User: NSObject {
    
    /*email, password, social_login(If social media login then 1 else 0), facebook_id, google_id, profile_image_url, device_id,  first_name, last_name, phone*/
    
    var app_user_id: String = ""
    var created_at: String = ""
    var status: String = ""
    var user_address: String = ""
    var user_age: String = ""
    var user_city: String = ""
    var user_contact: String = ""
    var user_firstname: String = ""
    var user_gender: String = ""
    var user_lastname: String = ""
    var user_name: String = ""
    var user_otp: String = ""
    var user_otp_count: String = ""
    var user_password: String = ""
    var user_register_date: String = ""
    var user_sms_count: String = ""
}

struct LoginModel : Codable {
    
    let msg : String?
    let result : [Result]?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case result = "result"
        case status = "status"
    }
}
struct Result : Codable {
    
    let appUserId : String?
    let createdAt : String?
    let status : String?
    let userAddress : String?
    let userAge : String?
    let userCity : String?
    let userContact : String?
    let userFirstname : String?
    let userForgotCount : String?
    let userForgotDate : String?
    let userForgotOtp : String?
    let userGender : String?
    let userLastname : String?
    let userName : String?
    let userOtp : String?
    let userOtpCount : String?
    let userPassword : String?
    let userRegisterDate : String?
    let userSmsCount : String?
    
    enum CodingKeys: String, CodingKey {
        case appUserId = "app_user_id"
        case createdAt = "created_at"
        case status = "status"
        case userAddress = "user_address"
        case userAge = "user_age"
        case userCity = "user_city"
        case userContact = "user_contact"
        case userFirstname = "user_firstname"
        case userForgotCount = "user_forgot_count"
        case userForgotDate = "user_forgot_date"
        case userForgotOtp = "user_forgot_otp"
        case userGender = "user_gender"
        case userLastname = "user_lastname"
        case userName = "user_name"
        case userOtp = "user_otp"
        case userOtpCount = "user_otp_count"
        case userPassword = "user_password"
        case userRegisterDate = "user_register_date"
        case userSmsCount = "user_sms_count"
    }
}

struct ForgotPAssowrdModel : Codable {
    
    let msg : String?
    let otp : Int?
    let status : Int?
    let userId : String?
    
    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case otp = "otp"
        case status = "status"
        case userId = "user_id"
    }
}
