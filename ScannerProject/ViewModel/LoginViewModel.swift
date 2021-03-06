//
//  LoginViewModel.swift
//  ScannerProject
//
//  Created by Om on 04/03/21.
//  Copyright © 2021 Hitexa. All rights reserved.
//

import Foundation

protocol LoginDelegate {
    func onLoginSuccess()
    func ForgotPasswordSuccess()
}

class LoginViewModel {
    
    var delegate : LoginDelegate?
    var loginData: LoginModel?
    var ForgotPasswordData: ForgotPAssowrdModel?
    func loginApiCall(userName: String,password: String)
    {
        Loader.manager.startLoading()
        let param: [String: Any] = ["username": userName,
                                    "password": password]
        APIClient.default.makeRequest(httpMethod: .post, parameters: param, apiPath: APIClient.apiPath.login.rawValue, api: "") { (response) in
            Loader.manager.stopLoading()
            let status = response["status"] as! Int
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: response,
                options: []) {
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                print("JSON string = \(theJSONText!)")

            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.loginData = try JSONDecoder().decode(LoginModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.onLoginSuccess()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
            
        }
        
    }
    func callForgotPasswordApi(Email: String)
    {
        let param: [String: Any] = ["user_id": Email,"key":"forgot_password"]
        APIClient.default.makeRequest(httpMethod: .post, parameters: param, apiPath: APIClient.apiPath.SmsSend.rawValue, api: "") { (response) in
            print(response)
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: response,
                options: []) {
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                print("JSON string = \(theJSONText!)")

            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.ForgotPasswordData = try JSONDecoder().decode(ForgotPAssowrdModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.ForgotPasswordSuccess()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
    }
}
