//
//  LoaderManager.swift
//  DYNASTY
//
//  Created by Chetan Panchal on 10/08/20.
//  Copyright © 2020 Exaltare Technologies. All rights reserved.
//

import Foundation
import UIKit


/// UIActivityIndicator
class Loader {
    
    static let manager = Loader()
    let loaderView = LoaderView()
    
    
    /// gets currents view controller
    let rootController: UIViewController? = {
        let currentVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let app = UIApplication.shared.delegate as! AppDelegate
        return currentVC?.rootViewController
    }()
    
    
    /// shows UIActivityindicator on view controller
    func startLoading() {
        self.loaderView.frame = self.rootController?.view.frame ?? CGRect.zero
        self.loaderView.center = self.rootController?.view.center ?? CGPoint.zero
        self.rootController?.view.addSubview(self.loaderView)
        self.loaderView.startLoader()
    }
    
    /// hides UIActivityindicator on view controller
    func stopLoading() {
        DispatchQueue.main.async {
            self.loaderView.stopLoader()
        }
    }
}
