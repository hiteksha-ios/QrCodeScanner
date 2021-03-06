//
//  InstantiateVC.swift
//  ScannerProject
//
//  Created by Hitexa on 13/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import UIKit

class InstantiateVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isLogin")
        {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        else
        {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
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
