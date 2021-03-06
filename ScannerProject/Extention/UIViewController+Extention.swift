//
//  UIViewController+Extention.swift
//  ScannerProject
//
//  Created by Hitexa on 09/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import Foundation
import UIKit
import ValidationTextField
import DropDown
extension UIViewController {
    
   func setTextViewAttribute(textFieldName : ValidationTextField, PlaceholderText : String){
                
        textFieldName.placeholder = PlaceholderText
        textFieldName.titleText = PlaceholderText
        textFieldName.isUseTitle = true
        textFieldName.isShowTitle = false
        textFieldName.successImage = UIImage(named: "succees.png")
        textFieldName.errorImage = UIImage(named: "succees.png")
        textFieldName.validCondition = {
           $0.count > 0
        }
    }
    @objc func dismissKeyboard() {
           DispatchQueue.main.async {
               self.view.endEditing(true)
           }
       }
    func configureDropDown(container : UIView, arrValues : [String]) -> DropDown{
        
        let dropDown = DropDown()

        dropDown.anchorView = container // UIView or UIBarButtonItem

        dropDown.dataSource = arrValues

        dropDown.layer.cornerRadius = 10
        dropDown.backgroundColor = .white
     //   dropDown.addShadow(color: Color.APP_COLOR_MEDIUM_GRAY, opacity: 0.4, offset: CGSize(width: 0, height: 2), radius: 4)
        dropDown.direction = .bottom
        dropDown.width = container.frame.size.width
        dropDown.show()
        DropDown.startListeningToKeyboard()
        
        return dropDown
        
    }
    func setTextFieldText(textFieldName : ValidationTextField, value : String){

        if value.count > 0 {
            textFieldName.isValid = true
        }
        
        textFieldName.text = value
        var placeHolder = ""
        
        if let placeValue = textFieldName.placeholder{
            placeHolder = placeValue
        }
        let title = textFieldName.titleText
        textFieldName.placeholder = placeHolder
        textFieldName.titleText = title
        textFieldName.isUseTitle = true
        textFieldName.isShowTitle = false
        
    }
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
