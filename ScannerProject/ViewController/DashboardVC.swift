//
//  DashboardVC.swift
//  ScannerProject
//
//  Created by Hitexa on 12/08/20.
//  Copyright © 2020 Hitexa. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var userProfile: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var leadingOfSideView: NSLayoutConstraint!
    @IBOutlet weak var exitFromApp: UIButton!
    
    
    
    @IBOutlet weak var welcomeLbl: UILabel!
    
    
    @IBOutlet weak var scanView: UIView!
    
    @IBOutlet weak var sideView: UIView!
    
    
    
    let dashboardVM: DashboardViewmodel = {
        return DashboardViewmodel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultData()
        dashboardVM.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func setDefaultData()
    {
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        UserDefaults.standard.synchronize()
        mainView.layer.cornerRadius = 35
        exitFromApp.addCornerRadius(exitFromApp.frame.height/2)
        scanView.addCornerRadius(5)
        userProfile.addCornerRadius(userProfile.frame.size.height/2)
        userName.text = UserDefaults.standard.value(forKey: "UserFullName") as? String ?? ""
        welcomeLbl.text = "Welcome \(UserDefaults.standard.value(forKey: "UserFullName") as? String ?? "")"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        leadingOfSideView.constant = -(sideView.frame.size.width)
    }
    @IBAction func onBackBtn(_ sender: Any)
    {
        leadingOfSideView.constant = -(sideView.frame.size.width)
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .autoreverse, animations: {
            self.leadingOfSideView.constant = 0
        }, completion: nil)
    }
    
    @IBAction func onLogoutBtn(_ sender: Any)
    {
        
        
        let alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            alert -> Void in
            
            UserDefaults.standard.set(false, forKey: "isLogin")
            UserDefaults.standard.synchronize()
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        })
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScannerVC"
        {
            let destinationVC = segue.destination as! ScannerVC
        }
        
    }
    
    
    @IBAction func onsideView(_ sender: UIButton)
    {
        leadingOfSideView.constant = 0
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .autoreverse, animations: {
            self.leadingOfSideView.constant = -(self.sideView.frame.size.width)
        }, completion: nil)
    }
    
    @IBAction func onExitFromApp(_ sender: Any)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              exit(0)
             }
        }
    }
    
    
    @IBAction func onScanQrCode(_ sender: Any)
    {
        onsideView(UIButton())
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScannerVC") as! ScannerVC
        secondViewController.delegate = self
        secondViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(secondViewController, animated: true, completion: nil)
    }
    
    @IBAction func onEditProfile(_ sender: Any)
    {
        onsideView(UIButton())
        dashboardVM.callFetchUserDataApi()
    }
    
    
    
}

extension DashboardVC:scannerProtocol
{
    func GetScanCode(Code: String) {
        Utility.shared.showLoader(view: self.view)
        let param: [String: Any] = ["qrcode_name": Code,
                                    "app_id": UserDefaults.standard.value(forKey: "UserID") ?? ""]
        dashboardVM.scanCodeApi(parameter: param)
    }
}



extension DashboardVC: DashboardDelegate {
    func FetchedUserSuccessfully() {
        if dashboardVM.userData?.status == 1
        {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
            secondViewController.userData = dashboardVM.userData?.result?[0]
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
            
        else
        {
            //error
            Utility.presentAlertWithTitleAndMessage(message: dashboardVM.userData?.msg ?? "", hostVC: self) {
            }
        }
    }
    func ScanCodeResponseSuccess() {
        if dashboardVM.DataModel?.status == 1
        {
            _ = SweetAlert().showAlert("Good job!", subTitle: "You Scan The Code Successfully", style: AlertStyle.success)
        }
        else
        {
            //error
            
            Utility.presentAlertWithTitleAndMessage(message: dashboardVM.DataModel?.msg ?? "", hostVC: self) {
            }
        }
    }
}
