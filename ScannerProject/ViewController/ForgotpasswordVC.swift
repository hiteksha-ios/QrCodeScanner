//
//  ForgotpasswordVC.swift
//  ScannerProject
//
//  Created by Hitexa on 22/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import UIKit
import ValidationTextField

class ForgotpasswordVC: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var txtPassword: ValidationTextField!
    
    @IBOutlet weak var txtConfirmPassword: ValidationTextField!
    
    @IBOutlet weak var updatePaswordBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setTextViewAttribute(textFieldName: txtPassword, PlaceholderText: "Password")
        self.setTextViewAttribute(textFieldName: txtConfirmPassword, PlaceholderText: "Confirm Password")
        txtPassword.errorMessage = "Please Enter Password"
        txtConfirmPassword.errorMessage = "Please Enter Confirm PAssword"
        updatePaswordBtn.layer.cornerRadius = updatePaswordBtn.frame.size.height/2
        mainView.layer.cornerRadius = 35
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onUpdatePasswordBtn(_ sender: Any)
    {
        checkValidation()
    }
    
    func checkValidation()
    {
        if(txtPassword.text?.isEmpty ?? true){
            Utility.showAlertView(txtPassword.errorMessage!, hostVC: self)
            return
        }
        else if(txtConfirmPassword.text?.isEmpty ?? true){
            Utility.showAlertView(txtConfirmPassword.errorMessage!, hostVC: self)
            return
        }
        else if(txtConfirmPassword.text != txtPassword.text)
        {
            Utility.showAlertView("PAssword And Confirm PAssword Didn't Match", hostVC: self)
            return
        }
        else {
            
            UpdateApiCall()
        }
    }
    func UpdateApiCall()
    {
        
        let param: [String: Any] = ["user_id": UserDefaults.standard.value(forKey: "UserID") ?? "",
                                    "password": txtPassword.text!]
        APIClient.default.makeRequest(httpMethod: .post, parameters: param, apiPath: APIClient.apiPath.ForgotPassword.rawValue, api: "") { (response) in
            Utility.shared.hideLoader(view: self.view)
            print(response)
            let status = response["status"] as! Int
            if status == 1
            {
               // UserDefaults.standard.set("\(response["user_id"] as! Int)", forKey: "UserID")
               // UserDefaults.standard.set(response["user_name"] as! String, forKey: "UserName")
                //UserDefaults.standard.set(userFullName, forKey: "UserFullName")
                Utility.presentAlertWithTitleAndMessage(message: response["msg"] as! String? ?? "", hostVC: self)
                {
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
                
            }
            else
            {
                Utility.presentAlertWithTitleAndMessage(message: response["msg"] as! String? ?? "", hostVC: self) {
                }
            }
        }
    }
    @IBAction func onBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
