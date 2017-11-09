//
//  Extensions.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    enum FontIdentifier: String {
        
        case DisplayLight = "HelveticaNeue-Light",
        DisplayUltraLight = "HelveticaNeue-Ultralight",
        DisplayRegular = "HelveticaNeue",
        DisplayHeavy = "SFUIDisplay-Heavy"
    }
}

extension UILabel {
    func customFont(typeValue: UIFont.FontIdentifier, size: CGFloat) {
        self.font = UIFont(name: typeValue.rawValue, size: size)
    }
}

extension UITextField {
    func customFont(typeValue: UIFont.FontIdentifier, size: CGFloat) {
        self.font = UIFont(name: typeValue.rawValue, size: size)
    }
}

//MARK: UINavigationController

extension UINavigationController {
    func setNavigationBarFontSize(size: CGFloat) {
        let titleUIDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: size)!]
        
        UINavigationBar.appearance().titleTextAttributes = titleUIDict as? [String : AnyObject]
    }
    
    func addNavigationBarTitle(title title: String) {
        let label = UILabel()
        label.customFont(.DisplayUltraLight, size: kNavigationFontSize)
        label.text = title
        label.textColor = UIColor.whiteColor()
        label.tag = 1
        self.navigationBar.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.navigationBar.snp_center)
        }
    }
    
    func changeNavigationBarImageWithFade(duration: Double, imageIdentifier: UIImage.AssetIdentifier) {
        
        let animation = CATransition()
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        
        self.navigationBar.layer .addAnimation(animation, forKey: nil)
        
        UIView.animateWithDuration(duration, animations: {
            self.navigationBar.setBackgroundImage(UIImage(assetIdentifier: imageIdentifier), forBarMetrics: UIBarMetrics.Default)
        })
    }
    
    func bringTitleToFront() {
        for navView in self.navigationBar.subviews {
            if (navView is UILabel) {
                self.navigationBar.bringSubviewToFront(navView)
            }
        }
    }
}

//MARK: UIImage

extension UIImage {
    
    enum AssetIdentifier: String {
        case Moon = "moon"
        case Sunrise = "sunrise"
        case Music = "music"
        case Settings = "settings"
        case AnimationBackground = "animationBackground"
        case Clouds = "clouds"
        case AnimationSun = "animationSun"
        case AnimationMoon = "animationMoon"
        case Background = "background"
        case NavigationBackground = "navigationBackground"
        case WakeWellBackground = "wakeWellBackground"
        case WakeWellNavigationBackground = "wakeWellNavigationBackground"
        case WhitePillow = "whitePillow"
        case StarsBackground = "starsBackground"
        case iPhone = "iPhone5"
        case CloseIcon = "closeIcon"
        case MusicMax = "musicMax"
        case MusicMin = "musicMin"
        case PlayIcon = "playIcon"
        case StopIcon = "stopIcon"
        case FirstPage = "firstPage"
        case SecondPage = "secondPage"
        case ThirdPage = "thirdPage"
        case JeniusLogicLogo = "jeniusLogo"
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.startIndex.advancedBy(1)
            hex         = hex.substringFromIndex(index)
        }
        
        let scanner = NSScanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexLongLong(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

//MARK: UIViewController

extension UIViewController {
    
    func createAlertController(title: String, message: String) {
        
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func hideActivityIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

//MARK: UIView

extension UIView {
    func addBackgroundInterpolationMovement() {
        
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = 10
        verticalMotionEffect.maximumRelativeValue = -10
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = 10
        horizontalMotionEffect.maximumRelativeValue = -10
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        self.addMotionEffect(group)
    }
    
    func addForegroundInterpolationMovement() {
        
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        self.addMotionEffect(group)
    }
}

//MARK: UITableView
extension UITableView {
 
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
            { _ in completion() }
    }
}

//MARK: UIButton
extension UIButton {
    func underlineButton() {
        let titleString : NSMutableAttributedString = NSMutableAttributedString(string: self.titleLabel!.text!)
        titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, self.titleLabel!.text!.length))
        self.setAttributedTitle(titleString, forState: .Normal)
    }
}
