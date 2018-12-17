//
//  Constants.swift
//  Weather
//
//  Created by Tarasenko Jurik on 12/17/18.
//  Copyright © 2018 Next Level. All rights reserved.
//

import UIKit

enum StoryboardName: String {
    case main = "Main"
}

extension UIViewController {
    
    class func instance(_ storyboard: StoryboardName = .main) -> Self {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let viewController = storyboard.instantiateViewController(self)
        return viewController
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        let id = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: id) as! T
    }
}

extension NSObject {
    class var identifier: String {
        return String(describing: self)
    }
}

extension UIColor {
    
    class func hexStr (_ hexStr : String, alpha : CGFloat) -> UIColor {
        var hexStr = hexStr
        hexStr = hexStr.replacingOccurrences(of: "#", with: "") as String
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.white;
        }
    }
    
    static let weatherBlack = UIColor.hexStr("#191D20", alpha: 1)
    static let weatherGrayBlack = UIColor.hexStr("#1F2427", alpha: 1)
    static let weatherOrange = UIColor.hexStr("#F58223", alpha: 1)
    static let weatherWhite = UIColor.hexStr("#FFFFFF", alpha: 1)
    static let whiteCell = UIColor.white.withAlphaComponent(0.15)
}

extension UIViewController {
    
    func showAlert(title: String, msg: String, customActions: [UIAlertAction] = []) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            
            if customActions.isEmpty {
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            } else {
                for action in customActions {
                    alert.addAction(action)
                }
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension Double {
    
    func fromKelvinToCelsius() -> String {
        return String(format: "%.0f", self - 273.15)
    }
}
