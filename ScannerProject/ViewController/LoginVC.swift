//
//  LoginVC.swift
//  ScannerProject
//
//  Created by Hitexa on 08/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import UIKit
import ValidationTextField
import Alamofire
class LoginVC: UIViewController {
    
    @IBOutlet weak var userNameTxtField: ValidationTextField!
    
    @IBOutlet weak var passwordTextField: ValidationTextField!
    
  //  @IBOutlet weak var emailTextField: ValidationTextField!
    
    
    let loginVM: LoginViewModel = {
        return LoginViewModel()
    }()
    @IBOutlet weak var loginBtn: UIButton!
    var emailTextField: ValidationTextField?
    var textField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loginVM.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setUpUI()
    {
        self.setTextViewAttribute(textFieldName: userNameTxtField, PlaceholderText: "Username")
        self.setTextViewAttribute(textFieldName: passwordTextField, PlaceholderText: "Password")
        userNameTxtField.errorMessage = "Please Enter Username"
        passwordTextField.errorMessage = "Please Enter Password"
        loginBtn.layer.cornerRadius = loginBtn.frame.size.height/2
    }
    @IBAction func onLoginBtn(_ sender: Any)
    {
        checkValidation()
        //loginApiCall()
    }
    func checkValidation()
    {
        self.dismissKeyboard()
        let userName = userNameTxtField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if(userName == ""){
            Utility.showAlertView(userNameTxtField.errorMessage ?? "Please Enter Username", hostVC: self)
            return
        }
        else if(password == "") {
            Utility.showAlertView(passwordTextField.errorMessage ?? "Please Enter Password", hostVC: self)
            return
        } else {
            loginVM.loginApiCall(userName: userName, password: password)
        }
    }
    @IBAction func onForgotPasswordBtn(_ sender: Any)
    {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)

        
        alert.addTextField {
            $0.placeholder = "Enter Your Registered Email.."
            $0.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let loginAction = UIAlertAction(title: "Submit", style: .default) { [unowned self] _ in
            guard (alert.textFields?[0].text) != nil
                else { return } // Should never happen
            loginVM.callForgotPasswordApi(Email: alert.textFields?[0].text ?? "" )
            print(alert.textFields?[0].text ?? "")
            // Perform login action
        }
        loginAction.isEnabled = false
        alert.addAction(loginAction)
        self.present(alert, animated: true, completion:nil)
    }
    @IBAction func onSignUpBtn(_ sender: Any)
    {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
}


extension LoginVC: LoginDelegate {
    func ForgotPasswordSuccess() {
        if loginVM.ForgotPasswordData?.status == 0
        {
            
            Utility.presentAlertWithTitleAndMessage(message: loginVM.ForgotPasswordData?.msg ?? "", hostVC: self)
                {

                }
        }
        if loginVM.ForgotPasswordData?.status == 1
        {
            UserDefaults.standard.set(loginVM.ForgotPasswordData?.userId ?? "", forKey: "UserID")
                Utility.presentAlertWithTitleAndMessage(message: loginVM.ForgotPasswordData?.msg ?? "", hostVC: self)
                {
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    secondViewController.isforgotPAssword = true
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
        }
    }
    
    func onLoginSuccess() {
        if loginVM.loginData?.status == 1
        {
            //registration complete
            let userFullName = "\(loginVM.loginData?.result?[0].userFirstname ?? "")" + " " +  "\(loginVM.loginData?.result?[0].userLastname ?? "")"
            UserDefaults.standard.set(loginVM.loginData?.result?[0].appUserId ?? "", forKey: "UserID")
            UserDefaults.standard.set(loginVM.loginData?.result?[0].userName ?? "", forKey: "UserName")
            UserDefaults.standard.set(userFullName, forKey: "UserFullName")
            UserDefaults.standard.synchronize()
            Utility.presentAlertWithTitleAndMessage(message: loginVM.loginData?.msg ?? "", hostVC: self)
            {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
        }else if loginVM.loginData?.status == 2
        {
            //registrastion imcomplete
            let userFullName = "\(loginVM.loginData?.result?[0].userFirstname ?? "")" + " " +  "\(loginVM.loginData?.result?[0].userLastname ?? "")"
            UserDefaults.standard.set(loginVM.loginData?.result?[0].appUserId ?? "", forKey: "UserID")
            UserDefaults.standard.set(loginVM.loginData?.result?[0].userName ?? "", forKey: "UserName")
            UserDefaults.standard.set(userFullName, forKey: "UserFullName")
            UserDefaults.standard.synchronize()
                Utility.presentAlertWithTitleAndMessage(message: loginVM.loginData?.msg ?? "", hostVC: self)
                {
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
        }
        else
        {
//            error
                Utility.presentAlertWithTitleAndMessage(message: loginVM.loginData?.msg ?? "", hostVC: self) {
                }
        }
    }
}
