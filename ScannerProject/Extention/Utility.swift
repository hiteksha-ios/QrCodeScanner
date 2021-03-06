//
//  Utility.swift
//  ProjectStructure
//
//  Created by Sunil Zalavadiya on 01/05/18.
//  Copyright © 2018 Sunil Zalavadiya. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MBProgressHUD
import Toast_Swift

class Utility
{
    //MARK: - Variables
    static let shared = Utility()
    
    
    let viewLoader = UIView()
    let imgLoader = UIImageView()
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    
    
    var enableLog = true
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    //MARK: - Functions
    class func isLogEnable() -> Bool
    {
        return self.shared.enableLog
    }
    
    class func enableLog()
    {
        self.shared.enableLog = true
    }
    
    class func disableLog()
    {
        self.shared.enableLog = false
    }
    
    class func appDelegate() -> AppDelegate
    {
        return self.shared.appDelegate
    }
    
    class func windowMain() -> UIWindow?
    {
        return self.appDelegate().window
    }
    
    class func rootViewControllerMain() -> UIViewController?
    {
        return self.windowMain()?.rootViewController
    }
    
    class func applicationMain() -> UIApplication
    {
        return UIApplication.shared
    }
    
    class func getMajorSystemVersion() -> Int
    {
        let systemVersionStr = UIDevice.current.systemVersion   //Returns 7.1.1
        let mainSystemVersion = Int((systemVersionStr.split(separator: "."))[0])
        
        return mainSystemVersion!
    }
    
    class func getAppUniqueId() -> String
    {
        let uniqueId: UUID = UIDevice.current.identifierForVendor! as UUID
        
        return uniqueId.uuidString
    }
    
    class func isLocationServiceEnable() -> Bool
    {
        var locationOn:Bool = false
        
        if(CLLocationManager.locationServicesEnabled())
        {
            
            if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse)
            {
                locationOn = true
            }
            else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
            {
                locationOn = true
            }
        }
        else
        {
            locationOn = false
        }
        
        return locationOn
    }
    
    
    class func getJsonString(jsonObject: Any) -> String?
    {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            return jsonData.getUtf8String()
        }
        catch let error
        {
            DLog("Error!! = \(error)")
        }
        
        return nil
    }
    
    class func getJsonObject(data: Data) -> Any?
    {
        do
        {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        }
        catch let error
        {
            DLog("Error!! = \(error)")
        }
        
        return nil
    }
    
    class func showMessageAlert(title: String, andMessage message: String, withOkButtonTitle okButtonTitle: String)
    {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    func EmailValidation(string :String) -> Bool {
        let emailRegEx = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    func validateURL(string: String) -> Bool {
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: string)
        return result
    }
    
    func validatePassword(string: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: string)
        
        return isMatched
    }
    
    func MobileValidation(MobileNumber : String) -> Bool {
        
        if MobileNumber.isNumeric{
            if MobileNumber.count >= 10{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func showLoader(view: UIView)
    {
        DispatchQueue.main.async {
            
            self.createLoader(addView: view)
            self.showLoading()
        }
    }
    
    func hideLoader(view: UIView)
    {
        
        DispatchQueue.main.async {
            
            self.animation.repeatCount = 0
            self.viewLoader.isHidden = true
            self.viewLoader.removeFromSuperview()
            
        }
    }
    
    
    //MARK:- Show loader
    private func showLoading(){
        viewLoader.isHidden = false
        
        animation.fromValue = NSNumber(value: 0.0)
        animation.toValue = NSNumber(value: 2 * Float.pi)
        animation.duration = 1.0
        animation.repeatCount = .infinity
        imgLoader.layer.add(animation, forKey: "SpinAnimation")
    }
    
    
    //MARK:- create loader
    func createLoader(addView: UIView) {
        viewLoader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        viewLoader.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewLoader.isHidden = true
        
        imgLoader.image = UIImage(named: "frame-0")
        imgLoader.frame = CGRect(x: (UIScreen.main.bounds.width / 2.0) - 35.0, y: (UIScreen.main.bounds.height / 2.0) - 35.0, width: 70.0, height: 70.0)
        viewLoader.addSubview(imgLoader)
        addView.addSubview(viewLoader)
    }
    
    func showToast(_ alertMsg: String) -> Void {
        
        showToast(alertMsg, title: "")
    }
    
    
    func showToast(_ alertMsg: String , title : String) -> Void {
        
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow{
                
                window.hideAllToasts()
                window.makeToast(alertMsg, duration: 3.0, position: .bottom)
            }
        }
        
    }
    
    //MARK: --------------------------
    //MARK: Instantiate VC from Different StoryBoards
    //MARK: --------------------------
    
    
    
    
    class func showAlertView(_ alertMsg: String,  hostVC : UIViewController?) -> Void {
        
        let alertController = UIAlertController(title: "Scanner", message: alertMsg, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(doneAction)
        
        if let hostVC = hostVC{
            
            DispatchQueue.main.async(execute: {
                
                hostVC.present(alertController, animated: true, completion: nil)
            })
        }
        
        
    }
    class func presentAlertWithTitleAndMessage(message: String,hostVC : UIViewController?, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Scanner", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completion()
        }))
        if let hostVC = hostVC{
            
            DispatchQueue.main.async(execute: {
                
                hostVC.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    func formateDateDDMMYYYYFromString(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if date != nil{
            return dateFormatter.string(from: date!)
        } else {
            return ""
        }
    }
    
    func getDateFromTimestamp(_ stamp : Double, dateFormat : String) -> String{
        
        let date = Date(timeIntervalSince1970:stamp )
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = dateFormat
        //dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dayTimePeriodFormatter.string(from: date)
        
        return dateString
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

func DLog(_ items: Any?..., function: String = #function, file: String = #file, line: Int = #line)
{
    if(Utility.shared.enableLog)
    {
        print("-----------START-------------")
        let url = NSURL(fileURLWithPath: file)
        print("Message = ", items, "\n\n(File: ", url.lastPathComponent ?? "nil", ", Function: ", function, ", Line: ", line, ")")
        print("-----------END-------------\n")
    }
}

//MARK: - Structs
struct IOS_VERSION
{
    static var IS_IOS7 = Utility.getMajorSystemVersion() >= 7 && Utility.getMajorSystemVersion() < 8
    static var IS_IOS8 = Utility.getMajorSystemVersion() >= 8 && Utility.getMajorSystemVersion() < 9
    static var IS_IOS9 = Utility.getMajorSystemVersion() >= 9
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    //static let IS_TV = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.TV
    
    static let IS_IPHONE_4_OR_LESS =  IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 1125.0
}

//MARK: - String Extension
extension String
{
    func getUtf8Data() -> Data
    {
        return self.data(using: String.Encoding.utf8)!
    }
    
    /// EZSE: Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
    
    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    var isValidEmail: Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool
    {
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool
    {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[])[A-Za-z\\d$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[]{8,}"//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func getDateWithFormate(formate: String, timezone: String) -> Date
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        
        if let returnDate = formatter.date(from: self){
            return returnDate
        }else{
            return Date()
        }
    }
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    mutating func encodedUrlComponentString()
    {
        self = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    mutating func encodedUrlQueryString()
    {
        self = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

//MARK: - Data Extension
extension Data
{
    func getUtf8String() -> String
    {
        return String(data: self, encoding: String.Encoding.utf8)!
    }
    
    func getJsonObject() -> Any?
    {
        do
        {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
        }
        catch let error
        {
            DLog("Error!! = \(error)")
        }
        
        return nil
    }
}

//MARK: - All Int extensions
extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
    
    /// EZSE: Converts integer value to Double.
    public var toDouble: Double { return Double(self) }
    
    /// EZSE: Converts integer value to Float.
    public var toFloat: Float { return Float(self) }
    
    /// EZSE: Converts integer value to CGFloat.
    public var toCGFloat: CGFloat { return CGFloat(self) }
    
    /// EZSE: Converts integer value to String.
    public var toString: String { return String(self) }
    
    /// EZSE: Converts integer value to UInt.
    public var toUInt: UInt { return UInt(self) }
    
    /// EZSE: Converts integer value to Int32.
    public var toInt32: Int32 { return Int32(self) }
}

//MARK: - All UIView extensions
extension UIView
{
    func addCornerRadius(_ radius: CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func applyBorder(_ width: CGFloat, borderColor: UIColor)
    {
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
    }
    
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat)
    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}

extension UITextField
{
    func addLeftPadding(padding: CGFloat)
    {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        self.leftView = tempView
        self.leftViewMode = .always
    }
    
    func addRightPadding(padding: CGFloat)
    {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        self.rightView = tempView
        self.rightViewMode = .always
    }
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    
    func addImageToRightSide(image: UIImage, width: CGFloat)
    {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        imageView.contentMode = .center
        imageView.image = image
        
        self.rightView = imageView
        self.rightViewMode = .always
    }
    
    func addImageToLeftSide(image: UIImage, width: CGFloat)
    {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        imageView.contentMode = .center
        imageView.image = image
        
        self.leftView = imageView
        self.leftViewMode = .always
    }
    
    func addImageToLeftSide(image: UIImage, width: CGFloat, height: CGFloat)
    {
        //        let rightView = UIImageView()
        //        rightView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //        rightView.contentMode = .scaleAspectFit
        //        rightView.image = image
        //
        //        self.leftView = rightView
        //        self.leftViewMode = .always
        
        
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: height, height: width)//CGRect(x: 0, y: 0, width: width, height: height)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let tempView = UIView(frame: CGRect(x: 0, y: self.frame.height/2/4, width: width, height: self.frame.height))
        
        tempView.addSubview(imageView)
        imageView.center = tempView.center
        
        self.leftView = tempView
        self.leftViewMode = .always
    }
    
    func addRightDropDownArrow(image: UIImage, imageSize: CGSize)
    {
        let arrowImageview = UIImageView()
        arrowImageview.image = image
        arrowImageview.contentMode = .center
        arrowImageview.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        self.rightView = arrowImageview
        self.rightViewMode = .always
    }
}

//MARK: - All UIButton extensions
extension UIButton
{
    func centerVerticallyWithPadding(padding: CGFloat)
    {
        let imageSize: CGSize = (self.imageView?.frame.size)!
        let titleString: NSString = (self.titleLabel?.text)! as NSString
        let titleSize: CGSize = titleString.size(withAttributes: [NSAttributedString.Key.font: (self.titleLabel?.font)!])
        
        let totalHeight: CGFloat = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: 0.0, bottom: 0.0, right: -titleSize.width)
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0.0)
    }
    
    func centerVertically()
    {
        let kDefaultPadding: CGFloat  = 6.0;
        
        self.centerVerticallyWithPadding(padding: kDefaultPadding);
    }
    
    func setUnderlineButton()
    {
        let text = self.titleLabel?.text
        let titleString = NSMutableAttributedString(string: text!)
        titleString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, (text?.count)!))
        self.setAttributedTitle(titleString, for: .normal)
        
    }
}

//MARK: - All UIImage Extensions
extension UIImage
{
    
    func tintWithColor(_ color:UIColor) -> UIImage
    {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale);
        //UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context?.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
}

//MARK: - All Date Extension
extension Date
{
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Date
    {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date
    {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func addMinutes(minutes: Int) -> Date
    {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func getDateStringWithFormate(_ formate: String, timezone: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        
        return formatter.string(from: self)
    }
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}

//MARK: - Storyboard Extension
enum AppStoryboard : String {
    
    case Main
    case Client
    case Matters
    case Activity
    case Subscription
    case Calendar
    case NewsFeed
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

//MARK: - UIColor Extension
extension UIColor
{
    convenience init(hexString: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexString.hasPrefix("#")
        {
            let index   = hexString.index(hexString.startIndex, offsetBy: 1)
            let hex     = hexString.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexInt64(&hexValue)
            {
                if hex.count == 6
                {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                }
                else if hex.count == 8
                {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                }
                else
                {
                    print("invalid rgb string, length should be 7 or 9", terminator: "")
                }
            }
            else
            {
                print("scan hex error", terminator: "")
            }
        }
        else
        {
            print("invalid rgb string, missing '#' as prefix", terminator: "")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}


struct API
{
    static var BASE_URL = "https://www.rnwsofttech.com/qrscanner/admin/Api/"
    
    static let REGISTRATION  = BASE_URL + "app_user.php"
    
    static let LOGIN = BASE_URL + "login_user.php"
    
    
}
