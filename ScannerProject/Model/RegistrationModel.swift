//
//  RegistrationModel.swift
//  ScannerProject
//
//  Created by Om on 05/03/21.
//  Copyright © 2021 Hitexa. All rights reserved.
//

import Foundation

struct RegistrationModel : Codable {
    
    let msg : String?
    let status : Int?
    let userId : Int?
    let userName : String?
    
    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case status = "status"
        case userId = "user_id"
        case userName = "user_name"
    }
}

struct CityModel : Codable {
    
    let result : [CityResult]?
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}

struct CityResult : Codable {
    
    let cityId : String?
    let cityName : String?
    let createdAt : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case cityId = "city_id"
        case cityName = "city_name"
        case createdAt = "created_at"
        case status = "status"
    }
}
