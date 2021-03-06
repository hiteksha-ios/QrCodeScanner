//
//  VerificationVC.swift
//  ScannerProject
//
//  Created by Hitexa on 11/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import UIKit
import SVPinView

class VerificationVC: UIViewController {

    
    
    @IBOutlet weak var pinView: SVPinView!
    
    
    @IBOutlet weak var resendBtn: UIButton!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var otpString = String()
    var isforgotPAssword:Bool = false
    
    let verificationVM: VerificationViewModel = {
        return VerificationViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        verificationVM.delegate = self
        resendBtn.addCornerRadius(resendBtn.frame.height/2)
        submitBtn.addCornerRadius(submitBtn.frame.height/2)
        resendBtn.layer.borderWidth = 1.5
        resendBtn.layer.borderColor = UIColor.init(hexString: "#0645AD").cgColor
        configurePinView()
        resendBtn.isHidden = isforgotPAssword
    }
    override func viewWillAppear(_ animated: Bool) {
        let param: [String: Any] = ["user_id": UserDefaults.standard.value(forKey: "UserID") ?? ""]
        verificationVM.callSmsSendApi(parameter: param)
    }
    
    func configurePinView() {
        
        pinView.pinLength = 4
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 10
        pinView.textColor = UIColor.white
        pinView.borderLineColor = UIColor.white
        pinView.activeBorderLineColor = UIColor.white
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.style = .none
        pinView.fieldBackgroundColor = UIColor.init(hexString: "#0645AD").withAlphaComponent(1)
        pinView.activeFieldBackgroundColor = UIColor.init(hexString: "#0645AD").withAlphaComponent(1)
        pinView.fieldCornerRadius = 15
        pinView.activeFieldCornerRadius = 15
        pinView.placeholder = ""
        pinView.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        pinView.keyboardAppearance = .default
        pinView.tintColor = .white
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        
        pinView.font = UIFont.systemFont(ofSize: 18)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
            self.otpString = pin
            
        }
    }
    func didFinishEnteringPin(pin:String) {
        print(pin)
    }

    @IBAction func onBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onResendBtn(_ sender: Any)
    {
        let param: [String: Any] = ["user_id": UserDefaults.standard.value(forKey: "UserID") ?? ""]
        verificationVM.resendApiCall(parameter: param)
    }
     @IBAction func onSubmitBtn(_ sender: Any)
     {
        let param: [String: Any]
        if isforgotPAssword
        {
            param = ["user_id": UserDefaults.standard.value(forKey: "UserID") ?? "","otp": otpString,"key":"forgot_password"]
        }
        else
        {
            param = ["user_id": UserDefaults.standard.value(forKey: "UserID") ?? "","otp": otpString]
        }
        verificationVM.submitOTPApi(parameter: param)
     }
    
}


extension VerificationVC: VerificationDelegate {
    func SmsSendSuccessfully() {
        if verificationVM.DataModel?.status == 0
        {
            Utility.presentAlertWithTitleAndMessage(message: verificationVM.DataModel?.msg ?? "", hostVC: self)
            {
                
            }
        }
    }
    func ResendSmsSuccessfully() {
        if verificationVM.DataModel?.status == 1
        {
            //success
            Utility.presentAlertWithTitleAndMessage(message: verificationVM.DataModel?.msg ?? "", hostVC: self) {
            }
        }
        else
        {
            //error
            Utility.presentAlertWithTitleAndMessage(message: verificationVM.DataModel?.msg ?? "", hostVC: self) {
            }
        }
    }
    func ActiveUserSuccessfully() {
        if verificationVM.DataModel?.status == 1
        {
            
            Utility.presentAlertWithTitleAndMessage(message: verificationVM.DataModel?.msg ?? "", hostVC: self) {
                
                if self.isforgotPAssword
                {
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotpasswordVC") as! ForgotpasswordVC
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
                else
                {
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
                
            }
        }
        else
        {
            //error
            Utility.presentAlertWithTitleAndMessage(message: verificationVM.DataModel?.msg ?? "", hostVC: self) {
            }
        }
    }
}
