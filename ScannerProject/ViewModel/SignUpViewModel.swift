//
//  SignUpViewModel.swift
//  ScannerProject
//
//  Created by Om on 05/03/21.
//  Copyright © 2021 Hitexa. All rights reserved.
//

import Foundation
protocol SignUpDelegate {
    func RegistrationSuccess()
    func CityFetched()
}

class SignUpViewModel {
    
    var delegate : SignUpDelegate?
    var registrationData: RegistrationModel?
    var cityData: CityModel?
    func RegistrationApiCall(parameter: [String: Any])
    {
        Loader.manager.startLoading()
        APIClient.default.makeRequest(httpMethod: .post, parameters: parameter, apiPath: APIClient.apiPath.registration.rawValue, api: "") { (response) in
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
                self.registrationData = try JSONDecoder().decode(RegistrationModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.RegistrationSuccess()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
    }
    func fetchCity()
    {
        Loader.manager.startLoading()
        APIClient.default.makeRequest(httpMethod: .post, parameters: nil, apiPath: APIClient.apiPath.cityFetch.rawValue, api: "") { (response) in
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
                self.cityData = try JSONDecoder().decode(CityModel.self, from: jsonData)
                Loader.manager.stopLoading()
                self.delegate?.CityFetched()
            } catch {
                Loader.manager.stopLoading()
                print("loginModel Unexpected error: \(error).")
            }
        }
    }
}

