//
//  UIManager.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class UIManager: NSObject {

    static let sharedInstance = UIManager()
    
    func sonnoLabel(textSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.customFont(.DisplayLight, size: textSize)
        return label
    }
    
    func showStatusBar() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
    }
}
