//
//  APIClient.swift
//  DYNASTY
//
//  Created by Sanket Bhavsar on 25/06/20.
//  Copyright © 2020 Exaltare Technologies. All rights reserved.
//

import Foundation
import Alamofire

class APIClient: NSObject {
    
    public static let `default` = APIClient()
    
   // private let baseURL = "https://www.rnwsofttech.com/qrscanner/admin/Api/"
    private let baseURL = "https://openstoredoor.in/qrscanner/admin/Api/"
    
    enum apiPath : String {
        case login = "login_user.php"
        case registration = "app_user.php"
        case SmsSend = "sms_send.php"
        case ActiveUser = "active_user.php"
        case Resendotp = "resend_otp.php"
        case Scanner = "scanner_user.php"
        case userFetch = "user_fetch.php"
        case updateProfile = "update_profile.php"
         case cityFetch = "city_fetch.php"
        case ForgotPassword = "forgot_password.php"
        
        
    }
    
   
    
    required override init() {
        
    }
    
    var headers : HTTPHeaders = []
    
    func makeRequest(httpMethod: HTTPMethod, parameters:[String:Any]?, apiPath:String = "", api:String = "", completionHandler: (([String:Any]) -> Void)!) -> Void {
        
        let url = baseURL + apiPath + api
        //print(url)

        
        var encoding : ParameterEncoding!
        encoding = URLEncoding.default
        
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { (response) in
                    print(response.result)
                
                    switch response.result {
        
                    case .success(let value) :
                        
                        let response = value as! [String : Any]
                        if(response["status_code"] as? Int == 401) {
                        } else {
                            completionHandler(response)
                        }
                        break
                    case .failure( _):
                        break
                    }
                })
    }
}
