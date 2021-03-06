//
//  UpdateProfileVC.swift
//  ScannerProject
//
//  Created by Hitexa on 15/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import UIKit
import ValidationTextField

class UpdateProfileVC: UIViewController {
    
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var UpdateProfileBtn: UIButton!
    
    
    @IBOutlet weak var txtFirstName: ValidationTextField!
    @IBOutlet weak var txtLastName: ValidationTextField!
    @IBOutlet weak var txtUserName: ValidationTextField!
    @IBOutlet weak var txtPassword: ValidationTextField!
    @IBOutlet weak var txtMobileNumber: ValidationTextField!
    @IBOutlet weak var txtAge: ValidationTextField!
    @IBOutlet weak var txtCity: ValidationTextField!
    @IBOutlet weak var txtArea: ValidationTextField!
    @IBOutlet weak var cityBottomLabel: UILabel!
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var maleimg: UIImageView!
    @IBOutlet weak var femaleImg: UIImageView!
    @IBOutlet weak var otheImg: UIImageView!
    var userData: Result?
    var cityArray = [String]()
    var DateOfBirth = Date()
    
    let updateVM: EditViewModel = {
        return EditViewModel()
    }()
    let signUpVM: SignUpViewModel = {
        return SignUpViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        signUpVM.delegate = self
        signUpVM.fetchCity()
        updateVM.delegate = self
        // Do any additional setup after loading the view.
    }
    func setUpUI()
    {
        self.setTextViewAttribute(textFieldName: txtFirstName, PlaceholderText: "First Name")
        self.setTextViewAttribute(textFieldName: txtLastName, PlaceholderText: "Last Name")
        self.setTextViewAttribute(textFieldName: txtUserName, PlaceholderText: "Email Address")
        self.setTextViewAttribute(textFieldName: txtPassword, PlaceholderText: "Password")
        self.setTextViewAttribute(textFieldName: txtMobileNumber, PlaceholderText: "Mobile Number")
        self.setTextViewAttribute(textFieldName: txtAge, PlaceholderText: "Age")
        self.setTextViewAttribute(textFieldName: txtCity, PlaceholderText: "City")
        self.setTextViewAttribute(textFieldName: txtArea, PlaceholderText: "Area")
        txtFirstName.errorMessage = "Please Insert First Name"
        txtLastName.errorMessage = "Please Insert Last Name"
        txtUserName.errorMessage = "Please Insert Email Address"
        txtPassword.errorMessage = "Please Insert Password"
        txtMobileNumber.errorMessage = "Please Insert Mobile Number"
        txtAge.errorMessage = "Please Insert Age"
        txtCity.errorMessage = "Please Select City"
        txtArea.errorMessage = "Please Insert Area"
        
        mainView.layer.cornerRadius = 35
        UpdateProfileBtn.layer.cornerRadius = UpdateProfileBtn.frame.size.height/2
        userProfile.addCornerRadius(userProfile.frame.size.height/2)
        SetUserProfileData()
    }
    
    
    
    
    func SetUserProfileData()
    {
        self.setTextFieldText(textFieldName: self.txtFirstName, value: userData?.userFirstname ?? "")
        self.setTextFieldText(textFieldName: self.txtLastName, value: userData?.userLastname ?? "")
        self.setTextFieldText(textFieldName: self.txtUserName, value: userData?.userName ?? "")
        self.setTextFieldText(textFieldName: self.txtPassword, value: userData?.userPassword ?? "")
        self.setTextFieldText(textFieldName: self.txtMobileNumber, value: userData?.userContact ?? "")
        self.setTextFieldText(textFieldName: self.txtAge, value: userData?.userAge ?? "")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        self.DateOfBirth = dateFormatter.date(from: userData.user_age)!
        self.setTextFieldText(textFieldName: self.txtCity, value: userData?.userCity ?? "")
        self.setTextFieldText(textFieldName: self.txtArea, value: userData?.userAddress ?? "")
        if userData?.userGender ?? "" == "male"
        {
            maleimg.isHighlighted = true
        }
        else if userData?.userGender ?? "" == "female"
        {
            femaleImg.isHighlighted = true
        }
        else
        {
            otheImg.isHighlighted = true
        }
    }
    @IBAction func onBackBtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onUpdateProfileBtn(_ sender: Any)
    {
        checkValidation()
    }
    
    func checkValidation()
    {
        self.dismissKeyboard()
        
        if(txtFirstName.text?.isEmpty ?? true){
            Utility.showAlertView(txtFirstName.errorMessage!, hostVC: self)
            return
        }
        else if(txtLastName.text?.isEmpty ?? true){
            Utility.showAlertView(txtLastName.errorMessage!, hostVC: self)
            return
        }
        else if(txtUserName.text?.isEmpty ?? true){
            Utility.showAlertView(txtUserName.errorMessage!, hostVC: self)
            return
        }
        else if(!Utility.shared.EmailValidation(string: txtUserName.text!)){
            Utility.showAlertView("Please Enter Valid Email", hostVC: self)
            return
        }
        else if(txtPassword.text?.isEmpty ?? true){
            Utility.showAlertView(txtPassword.errorMessage!, hostVC: self)
            return
        }
        else if(txtMobileNumber.text?.isEmpty ?? true){
            Utility.showAlertView(txtMobileNumber.errorMessage!, hostVC: self)
            return
        }
        else if(!Utility.shared.MobileValidation(MobileNumber: txtMobileNumber.text!))
        {
            Utility.showAlertView("Please Enter Valid Mobile Number", hostVC: self)
            return
        }
        else if(!maleimg.isHighlighted && !femaleImg.isHighlighted && !otheImg.isHighlighted)
        {
            Utility.showAlertView("Please Select Any Gender", hostVC: self)
            return
        }
        else if(txtAge.text?.isEmpty ?? true){
            Utility.showAlertView(txtAge.errorMessage!, hostVC: self)
            return
        }
        else if(txtCity.text?.isEmpty ?? true){
            Utility.showAlertView(txtCity.errorMessage!, hostVC: self)
            return
        }
        else if(txtArea.text?.isEmpty ?? true){
            Utility.showAlertView(txtArea.errorMessage!, hostVC: self)
            return
        } else {
            
            UpdateProfileApiCall()
        }
    }
    
    
    func UpdateProfileApiCall()
    {
        Utility.shared.showLoader(view: self.view)
        var Gender = String()
        if maleimg.isHighlighted
        {
            Gender = "male"
        }
        else if femaleImg.isHighlighted
        {
            Gender = "female"
        }
        else
        {
            Gender = "other"
        }
        let param: [String: Any] = ["user_id": UserDefaults.standard.value(forKey: "UserID") ?? "","fname": txtFirstName.text!,
                                    "lname": txtLastName.text!,
                                    "username": txtUserName.text!,
                                    "password": txtPassword.text!,
                                    "contact": txtMobileNumber.text!,
                                    "age": txtAge.text!,
                                    "gender": Gender,
                                    "city": txtCity.text!,
                                    "address": txtArea.text!]
        print(param)
        updateVM.UpdateProfileApiCall(parameter: param)
    }
    @IBAction func onCityDropDownBtn(_ sender: UIButton)
    {
        self.dismissKeyboard()
        let dropDown = configureDropDown(container: self.cityBottomLabel, arrValues: cityArray)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.setTextFieldText(textFieldName: self.txtCity, value: item)
            dropDown.hide()
        }
    }
    @IBAction func onGenderBtn(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            maleimg.isHighlighted = true
            femaleImg.isHighlighted = false
            otheImg.isHighlighted = false
        }
        else if sender.tag == 1
        {
            maleimg.isHighlighted = false
            femaleImg.isHighlighted = true
            otheImg.isHighlighted = false
        }
        else
        {
            maleimg.isHighlighted = false
            femaleImg.isHighlighted = false
            otheImg.isHighlighted = true
        }
    }
    
    @IBAction func onAgeBtn(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addDatePicker(mode: .date, date: self.DateOfBirth == nil ? Date() : self.DateOfBirth, minimumDate: nil, maximumDate: Date()) { date in
            self.DateOfBirth = date
            let monthFormat = DateFormatter()
            monthFormat.dateFormat = "dd/MM/yyyy"
            let monthday = monthFormat.string(from: date)
            self.txtAge.text = "\(monthday.uppercased())"
        }
        // i pad uses
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = (sender as UIView)
        }
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler:
            { (action) in
                //                if self.expriationField.text == ""
                //                {
                //                    let monthFormat = DateFormatter()
                //                    monthFormat.dateFormat = "dd/MM/yyyy"
                //                    let monthday = monthFormat.string(from: Date())
                //                    self.expiredDate = Date()
                //                    self.expriationField.text = "\(monthday)"
                //                }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}



extension UpdateProfileVC: EditDelegate {
    func EditProfileSuccessfully() {
        if updateVM.DataModel?.status == 1
        {
            Utility.presentAlertWithTitleAndMessage(message: updateVM.DataModel?.msg ?? "", hostVC: self)
            {
                
            }
            
        }
        else
        {
            Utility.presentAlertWithTitleAndMessage(message: updateVM.DataModel?.msg ?? "", hostVC: self) {
            }
        }
    }
    func ScanCodeResponseSuccess() {
        
    }
}

extension UpdateProfileVC: SignUpDelegate {
    func RegistrationSuccess() {
    }
    func CityFetched() {
        for i in 0...((signUpVM.cityData?.result?.count ?? 0) - 1) {
            let data = signUpVM.cityData?.result?[i]
            self.cityArray.append(data?.cityName ?? "")
        }
    }
}
