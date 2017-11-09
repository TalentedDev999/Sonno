//
//  HomeView.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import Spring

protocol HomeViewDelegate: NSObjectProtocol {
    func setupSleep()
    func setupWake()
    func sendToAudio()
    func sendToSettings()
}

class HomeView: GenericView {
    
    //MARK: Config
    private struct SizesConfig {
        static let ButtonSize = CGSize(width: kScreenHeight/3, height: kScreenHeight/3)
    }
    
    let backgroundImageView = UIImageView(image: UIImage(assetIdentifier: .Background))
    let titleLabel = UILabel()
    let moonButton = UIButton()
    let sunriseButton = UIButton()
    let settingsButton = SpringButton()
    let musicButton = SpringButton()

    weak var delegate: HomeViewDelegate!

    override func commonInit() {
        
//        self.backgroundColor = kSonnoColor
        
        self.addSubview(backgroundImageView)
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).offset(UIEdgeInsets(top: -10, left: -10, bottom: 10, right: 10))
        }
        
        titleLabel.customFont(.DisplayUltraLight, size: kNavigationFontSize)
        titleLabel.text = "sonno"
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(20.0)
            make.centerX.equalTo(self)
        }
        
        moonButton.setImage(UIImage(assetIdentifier: .Moon), forState: UIControlState.Normal)
        moonButton.addTarget(self, action: "moonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        moonButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(moonButton)
        moonButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-kScreenHeight/5)
            if ScreenSizes.SmallScreen {
                make.size.equalTo(SizesConfig.ButtonSize)
            }
        }
        
        sunriseButton.setImage(UIImage(assetIdentifier: .Sunrise), forState: UIControlState.Normal)
        sunriseButton.addTarget(self, action: "sunrisePressed", forControlEvents: UIControlEvents.TouchUpInside)
        sunriseButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(sunriseButton)
        sunriseButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(kScreenHeight/5)
            if ScreenSizes.SmallScreen {
                make.size.equalTo(SizesConfig.ButtonSize)
            }
        }
        
        settingsButton.setImage(UIImage(assetIdentifier: .Settings), forState: UIControlState.Normal)
        settingsButton.addTarget(self, action: "settingsPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(settingsButton)
        settingsButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(15.0)
            make.bottom.equalTo(self).offset(-15.0)
        }
        
        musicButton.setImage(UIImage(assetIdentifier: .Music), forState: UIControlState.Normal)
        musicButton.addTarget(self, action: "musicPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(musicButton)
        musicButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-15.0)
            make.bottom.equalTo(settingsButton)
        }
    }

    func moonPressed() {
        self.delegate.setupSleep()
    }

    func sunrisePressed() {
        self.delegate.setupWake()
    }

    func musicPressed() {
        self.delegate.sendToAudio()
    }
    
    func settingsPressed() {
        self.delegate.sendToSettings()
    }
}
