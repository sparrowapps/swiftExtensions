//
//  Extensions.swift
//  VideoController
//
//  Created by sparrowapps on 2018. 4. 5..
//  Copyright © 2018년 sparrowapps. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

// UIView 를 UIImage로 변환
@objc extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.isOpaque, 0.0)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    public class func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIView {
    public class func findByAccessibilityIdentifier(_ identifier: String) -> UIView? {
        
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        
        func findByID(view: UIView, _ id: String) -> UIView? {
            if view.accessibilityIdentifier == id { return view }
            for v in view.subviews {
                if let a = findByID(view:v, id) { return a }
            }
            return nil
        }
        
        return findByID(view:window, identifier)
    }
    
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.accessibilityIdentifier = "activityIndicator"
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = activityColor
        
        activityIndicator.startAnimating()
        
        backgroundView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        let heightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        backgroundView.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
        layoutIfNeeded()
        
        self.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[backgroundView]|", options: [], metrics: nil, views: ["backgroundView": backgroundView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: [], metrics: nil, views: ["backgroundView": backgroundView]))
    }
    
    func activityStopAnimating() {
        if let view = UIView.findByAccessibilityIdentifier("activityIndicator") {
            view.removeFromSuperview()
        }
    }
    
    func startDimm() {
        let dimView = UIView()
        dimView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        dimView.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.3137254902, alpha: 0.6)
        dimView.accessibilityIdentifier = "dimming"
        self.addSubview(dimView)

        dimView.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
    }
    
    func removeDimm() {
        let dimmView = UIView.findByAccessibilityIdentifier("dimming")
        dimmView?.removeFromSuperview()
    }
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    // 네비게이션 바 그라데이션
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}

extension UIViewController {
    func addLeftBarButtonWithImage(_ buttonImage: UIImage?, action: Selector? ) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage!.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: action)
        
        navigationItem.setLeftBarButton(leftButton, animated: false)
    }
    
    func addLeftBarButtonWithText(_ text:String, TextColor textColor:UIColor , action: Selector? ) -> UIBarButtonItem {
        let leftButton : UIBarButtonItem = UIBarButtonItem(title: text, style: UIBarButtonItemStyle.plain, target: self, action: action)
        leftButton.setTitleTextAttributes([NSForegroundColorAttributeName: textColor], for: UIControlState.normal)
        
        navigationItem.setLeftBarButton(leftButton, animated: false)
        
        return leftButton
    }
    
    func addRightBarButtonWithImage(_ buttonImage: UIImage?, action: Selector? ) {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage!.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: action)
        
        navigationItem.setRightBarButton(rightButton, animated: false)
    }
    
    func addRightBarButtonWithText(_ text:String, TextColor textColor:UIColor , action: Selector? ) -> UIBarButtonItem {
        let rightButton : UIBarButtonItem = UIBarButtonItem(title: text, style: UIBarButtonItemStyle.plain, target: self, action: action)
        rightButton.setTitleTextAttributes([NSForegroundColorAttributeName: textColor], for: UIControlState.normal)
        
        navigationItem.setRightBarButton(rightButton, animated: false)
        
        return rightButton

    }
    
    func isLandscapeMode() -> Bool {
        let toInterfaceOrientation = UIApplication.shared.statusBarOrientation
        if toInterfaceOrientation == UIInterfaceOrientation.portrait || toInterfaceOrientation == UIInterfaceOrientation.portraitUpsideDown {
            return false
        } else {
            return true
        }
    }
}

extension String {
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    func substringWithRange(_ range:Range<Int>) -> String? {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return self.substring(with: start..<end)
    }
    
    var length: Int {
        return self.count
    }

    // 다국어지원
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UITextField {
    // 클리어 버튼 교체 
    func setClearButtonImage(_ image: UIImage) {
        clearButtonMode = UITextFieldViewMode.whileEditing
        if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(image, for: .normal)
        }
    }
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
