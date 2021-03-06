//
//  VerificationViewModel.swift
//  ScannerProject
//
//  Created by Om on 05/03/21.
//  Copyright © 2021 Hitexa. All rights reserved.
//

import Foundation
protocol VerificationDelegate {
    func SmsSendSuccessfully()
    func ResendSmsSuccessfully()
    func ActiveUserSuccessfully()
}

class VerificationViewModel {
    
    var delegate : VerificationDelegate?
    var DataModel: RegistrationModel?
    func callSmsSendApi(parameter: [String: Any])
    {
        APIClient.default.makeRequest(httpMethod: .post, parameters: parameter, apiPath: APIClient.apiPath.SmsSend.rawValue, api: "") { (response) in
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.DataModel = try JSONDecoder().decode(RegistrationModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.SmsSendSuccessfully()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
        
    }
    func resendApiCall(parameter: [String: Any]) {
        APIClient.default.makeRequest(httpMethod: .post, parameters: parameter, apiPath: APIClient.apiPath.Resendotp.rawValue, api: "") { (response) in
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.DataModel = try JSONDecoder().decode(RegistrationModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.ResendSmsSuccessfully()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
    }
    func submitOTPApi(parameter: [String: Any]) {
        APIClient.default.makeRequest(httpMethod: .post, parameters: parameter, apiPath: APIClient.apiPath.ActiveUser.rawValue, api: "") { (response) in
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.DataModel = try JSONDecoder().decode(RegistrationModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.ActiveUserSuccessfully()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
            
        }
    }
}

