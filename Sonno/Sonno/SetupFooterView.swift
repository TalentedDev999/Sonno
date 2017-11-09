//
//  SetupFooterView.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import MediaPlayer

protocol SetupFooterViewDelegate: NSObjectProtocol {
    func sendToAudio()
    func sendToSettings()
}

class SetupFooterView: GenericView {
    
    //MARK: Configuration Struct
    struct Config {
        static let WakeStartingAngle: Int = 256
        static let SleepStartingAngle: Int = 360 - 90
        static let ButtonSize = CGSize(width: kScreenHeight/3, height: kScreenHeight/3)
    }
    
    //MARK: Properties
    let imageView = UIImageView()
    var sliderPathColor: UIColor!
    var sliderThumbColor: UIColor!
    var unselectedPathColor: UIColor!
    var startingAngle: Int!
    var style: Style!
    var startingText: String!
    
    var volumeSlider: MGSlider!
    var volumeValue: Float = 0.5
    
    var circularSlider: BWCircularSlider!
    
    //Buttons
    let musicButton = UIButton()
    let settingsButton = UIButton()
    
    weak var delegate: SetupFooterViewDelegate!
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(type: SetupType) {
        
        //Start with option
        switch type.option {
        case SetupOption.Sleep:
            imageView.image = UIImage(assetIdentifier: .Moon)
            sliderPathColor = UIColor(hex: "FFFFFF")
            sliderThumbColor = UIColor(hex: "9B9B9B")
            unselectedPathColor = UIColor(hex: "1D3B56")
            startingAngle = Config.SleepStartingAngle
            style = Style.Minutes
        case SetupOption.Wake:
            imageView.image = UIImage(assetIdentifier: .Sunrise)
            sliderPathColor = UIColor(hex: "FFAF49")
            sliderThumbColor = UIColor(hex: "F97547")
            unselectedPathColor = UIColor(hex: "90A4B9").colorWithAlphaComponent(0.58)
            startingAngle = Config.WakeStartingAngle
            style = Style.Time
        }
        
        startingText = type.startTime
        
        super.init(frame: CGRectMake(0, 0, kScreenWidth, 350.0))
    }
    
    override func commonInit() {

        imageView.alpha = 0.15
        self.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(30.0)
            make.centerX.equalTo(self)
            if ScreenSizes.SmallScreen {
                make.size.equalTo(Config.ButtonSize)
            }
        }
        
        //Circular slider
        circularSlider = BWCircularSlider(startColor:sliderPathColor, endColor:sliderPathColor, frame: CGRectMake(0, 0, kCircularSliderSize, kCircularSliderSize), thumbColor: sliderThumbColor, unselectedPathColor: unselectedPathColor)
        circularSlider.angle = Int(startingAngle)
        circularSlider.style = style
        circularSlider.startingText = startingText
        self.addSubview(circularSlider)
        circularSlider.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(imageView)
            make.height.width.equalTo(kCircularSliderSize)
        }
        
        circularSlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        
        
//        let volumeView = MPVolumeView()
//        self.addSubview(volumeView)
//        volumeView.snp_makeConstraints { (make) -> Void in
//            make.bottom.equalTo(self).offset(-20.0)
//            make.width.equalTo(200.0)
//            make.centerX.equalTo(self)
//            make.height.equalTo(20.0)
//        }
        
        volumeSlider = MGSlider()
        volumeSlider.thumbTintColor = sliderThumbColor
        volumeSlider.minimumTrackTintColor = sliderPathColor
        volumeSlider.maximumTrackTintColor = unselectedPathColor
        volumeSlider.maximumValue = 1.0
        volumeSlider.minimumValue = 0.0
        volumeSlider.setValue(volumeValue, animated: false)
        volumeSlider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(volumeSlider)
        volumeSlider.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp_bottom).offset(40.0)
            make.width.equalTo(kScreenWidth/2.2)
            make.height.equalTo(20.0)
        }
        
        //Add volume icons
        let volumeMin = UIImageView(image: UIImage(assetIdentifier: .MusicMin))
        self.addSubview(volumeMin)
        volumeMin.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(volumeSlider.snp_left).offset(-10.0)
            make.centerY.equalTo(volumeSlider)
        }
        
        let volumeMax = UIImageView(image: UIImage(assetIdentifier: .MusicMax))
        self.addSubview(volumeMax)
        volumeMax.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(volumeSlider.snp_right).offset(10.0)
            make.centerY.equalTo(volumeSlider)
        }
        
        settingsButton.setImage(UIImage(assetIdentifier: .Settings), forState: UIControlState.Normal)
        settingsButton.addTarget(self, action: "settingsPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(settingsButton)
        settingsButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(30.0)
            make.centerY.equalTo(volumeSlider)
        }
        
        musicButton.setImage(UIImage(assetIdentifier: .Music), forState: UIControlState.Normal)
        musicButton.addTarget(self, action: "musicPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(musicButton)
        musicButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-30.0)
            make.centerY.equalTo(settingsButton)
        }
    }
    
    //MARK: Custom Methods
    func settingsPressed() {
        self.delegate.sendToSettings()
    }
    
    func musicPressed() {
        self.delegate.sendToAudio()
    }
    
    func sliderChanged(sender: UISlider) {        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationsConfig.VolumeSliderChanged, object: nil, userInfo: ["type" : style == .Minutes ? 0 : 1, "newValue" : sender.value])
    }
    
    func hideButtons() {
        musicButton.hidden = true
        settingsButton.hidden = true
    }
}
