//
//  File.swift
//  ScannerProject
//
//  Created by Om on 05/03/21.
//  Copyright © 2021 Hitexa. All rights reserved.
//

import Foundation
protocol EditDelegate {
    func EditProfileSuccessfully()
    func ScanCodeResponseSuccess()
}

class EditViewModel {
    
    var delegate : EditDelegate?
    var userData: LoginModel?
    var DataModel: RegistrationModel?
    func UpdateProfileApiCall(parameter: [String: Any])
    {
        Loader.manager.startLoading()
        APIClient.default.makeRequest(httpMethod: .post, parameters: parameter, apiPath: APIClient.apiPath.updateProfile.rawValue, api: "") { (response) in
            Loader.manager.stopLoading()
            print(response)
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: response,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                self.DataModel = try JSONDecoder().decode(RegistrationModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.EditProfileSuccessfully()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
    }
    
}
