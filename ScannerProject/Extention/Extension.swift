//
//  Extension.swift
//  ScannerProject
//
//  Created by Om on 04/03/21.
//  Copyright © 2021 Hitexa. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    func isValidEmail(_ email: String) -> Bool {
        return email.count > 0 && NSPredicate(format: "self matches %@", "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}").evaluate(with: email)
    }

    @objc func textDidChangeInLoginAlert() {
        if let email = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = isValidEmail(email)
        }
    }
}
