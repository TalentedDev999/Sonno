//
//  AnimationView.swift
//  Sonno
//
//  Created by Lucas Maris on 11/30/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import Spring
import SnapKit

protocol AnimationViewDelegate: NSObjectProtocol {
    func sendToHome()
    func sendToTutorial()
}

class AnimationView: GenericView {
    
    //MARK: Structs
    struct ElementSizes {
        static let ButtonsHeight: CGFloat = 50.0
        static let ButtonsBottomOffset: CGFloat = 40.0
    }

    //MARK: Properties
    private let backgroundImageView = UIImageView(image: UIImage(assetIdentifier: .Background))
    private let pillowImageView = SpringImageView(image: UIImage(assetIdentifier: .WhitePillow))
    private let tutorialButton = SpringButton()
    private let sleepJourneyButton = SpringButton()
    
    private var bottomConstraint: Constraint!
    
    weak var delegate: AnimationViewDelegate!

    override func commonInit() {
        
        backgroundImageView.addBackgroundInterpolationMovement()
        self.addSubview(backgroundImageView)
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).offset(UIEdgeInsets(top: -10, left: -10, bottom: 10, right: 10))
        }
    }
    
    func showLogo() {
        
        pillowImageView.addForegroundInterpolationMovement()
        pillowImageView.autohide = true
        pillowImageView.autostart = true
        pillowImageView.animation = "slideLeft"
        pillowImageView.curve = "spring"
        pillowImageView.duration = 1.33
        
        let label = UILabel()
        label.text = "Sonno"
        label.customFont(.DisplayUltraLight, size: 50.0)
        label.textColor = kSonnoBlueColor
        pillowImageView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(pillowImageView.snp_center)
        }
        
        self.addSubview(pillowImageView)
        pillowImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp_center)
        }
        
        //Buttons
        tutorialButton.addForegroundInterpolationMovement()
        tutorialButton.backgroundColor = kSonnoBlueColor
        tutorialButton.layer.cornerRadius = 5.0
        tutorialButton.setTitle("Tutorial", forState: UIControlState.Normal)
        tutorialButton.addTarget(self, action: "tutorialPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Animations
        tutorialButton.animation = "slideUp"
        tutorialButton.autostart = true
        tutorialButton.delay = 1.33
        
        self.addSubview(tutorialButton)
        tutorialButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(20.0)
            make.width.equalTo(kScreenWidth/2 - 40.0)
            self.bottomConstraint = make.bottom.equalTo(self).offset(-ElementSizes.ButtonsBottomOffset).constraint
//            make.bottom.equalTo(self).offset(-40.0)
            make.height.equalTo(ElementSizes.ButtonsHeight)
        }
        
        sleepJourneyButton.addForegroundInterpolationMovement()
        sleepJourneyButton.backgroundColor = UIColor.whiteColor()
        sleepJourneyButton.layer.cornerRadius = 5.0
        sleepJourneyButton.setTitle("Sleep Journey", forState: UIControlState.Normal)
        sleepJourneyButton.setTitleColor(kSonnoBlueColor, forState: UIControlState.Normal)
        sleepJourneyButton.addTarget(self, action: "sleepJourneyPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Animations
        sleepJourneyButton.animation = "slideUp"
        sleepJourneyButton.autostart = true
        sleepJourneyButton.delay = 1.33
        
        self.addSubview(sleepJourneyButton)
        sleepJourneyButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-20.0)
            make.bottom.height.width.equalTo(tutorialButton)
        }
        
//        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "animationFinished", userInfo: nil, repeats: false)
    }
    
    func animationFinished() {
        self.delegate.sendToHome()
    }
    
    func tutorialPressed() {
        
        hideViews()
        
        pillowImageView.animateNext { () -> () in
            self.pillowImageView.autostart = false
            self.tutorialButton.autostart = false
            self.sleepJourneyButton.autostart = false
            self.delegate.sendToTutorial()
        }
    }
    
    func sleepJourneyPressed() {
        hideViews()
        
        pillowImageView.animateNext { () -> () in
            self.pillowImageView.autostart = false
            self.tutorialButton.autostart = false
            self.sleepJourneyButton.autostart = false
            self.delegate.sendToHome()
        }
    }
    
    func hideViews() {
        
        pillowImageView.animation = "zoomOut"
        
        self.bottomConstraint.updateOffset(ElementSizes.ButtonsHeight)
        
        UIView.animateWithDuration(0.25,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
                self.layoutIfNeeded()
            }) { (finished) -> Void in
        }
    }
    
    func animateButtons() {
        sleepJourneyButton.animation = Spring.AnimationPreset.SlideUp.rawValue
        tutorialButton.animation = Spring.AnimationPreset.SlideUp.rawValue
        self.sleepJourneyButton.animate()
        self.tutorialButton.animate()
    }
    
    func restoreViews() {
        
        dispatch_async(dispatch_get_main_queue(),{
            
            self.pillowImageView.alpha = 0.0
            self.pillowImageView.animation = "zoomIn"
            self.pillowImageView.delay = 0.0
            
            self.pillowImageView.animateNext({ () -> () in
                
                self.bottomConstraint.updateOffset(-ElementSizes.ButtonsBottomOffset)
                
                //Animate buttons
                self.animateButtons()
                
            })
        })
    }
}
