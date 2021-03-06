//
//  DashboardViewmodel.swift
//  ScannerProject
//
//  Created by Om on 05/03/21.
//  Copyright © 2021 Hitexa. All rights reserved.
//

import Foundation
protocol DashboardDelegate {
    func FetchedUserSuccessfully()
    func ScanCodeResponseSuccess()
}

class DashboardViewmodel {
    
    var delegate : DashboardDelegate?
    var userData: LoginModel?
    var DataModel: RegistrationModel?
    func callFetchUserDataApi()
    {
        Loader.manager.startLoading()
        let param: [String: Any] = ["user_id": UserDefaults.standard.value(forKey: "UserID") ?? ""]
        APIClient.default.makeRequest(httpMethod: .post, parameters: param, apiPath: APIClient.apiPath.userFetch.rawValue, api: "") { (response) in
            Loader.manager.stopLoading()
            print(response)
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: response,
                options: []) {
                let theJSONText = String(data: theJSONData, encoding: .ascii)
                print("JSON string = \(theJSONText!)")

            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.userData = try JSONDecoder().decode(LoginModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.FetchedUserSuccessfully()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
    }
    
    func scanCodeApi(parameter: [String: Any]) {
        Loader.manager.startLoading()
        APIClient.default.makeRequest(httpMethod: .post, parameters: parameter, apiPath: APIClient.apiPath.Scanner.rawValue, api: "") { (response) in
            Loader.manager.stopLoading()
            print(response)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.DataModel = try JSONDecoder().decode(RegistrationModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.ScanCodeResponseSuccess()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
    }
}
