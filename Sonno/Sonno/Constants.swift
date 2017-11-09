//
//  Constants.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import Foundation
import UIKit

//MARK: App ID
struct AppStoreConfig {
    static let AppID: String = "1061755884"
}

//MARK:- Sizes
let kScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let kScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
let kNavigationFontSize: CGFloat = 36.0
let kScaleFactor: CGFloat = kScreenHeight > 500 ? 1.9 : 1.7
let kCircularSliderSize: CGFloat = ScreenSizes.SmallScreen ? kScreenHeight/kScaleFactor : 351.0
let kAnimationImageWidth: CGFloat = 5038.0
let kCloudsWidth: CGFloat = 278.0
let kAnimationSunWidth: CGFloat = 211.0
let kNavigationAndStatusBarHeight: CGFloat = 64.0

//Screens 
struct ScreenSizes {
    static let SmallScreen: Bool = kScreenWidth < 375.0
}

//MARK:- Notifications
let SonnoUpdatedPlaylist = "com.jeniusLogic.SonnoUpdatedPlaylist"

struct NotificationsConfig {
    static let PresentPremiumAd: String = "com.jeniusLogic.SonnoPresentPremiumAd"
    static let UpdatedCircularSliderValue: String = "com.jeniusLogic.SonnoUpdatedCiruclarSlider"
    static let ShakeToRestart: String = "com.jeniusLogic.SonnoShakeToRestart"
    static let VolumeSliderChanged: String = "com.jeniusLogic.SonnoVolumeSliderChanged"
}
let kPresentPremiumAd = "com.jeniusLogic.SonnoPresentPremiumAd"

//MARK:- NSUserDefaults
let kPlaylistCountKey = "com.jeniusLogic.SonnoPlaylistCount"

struct UserDefaultsConfig {
    static let AdMobOcurrenceDefault: String = "com.jeniusLogic.SonnoMobAdDefault"
    static let PremiumAdOcurrenceDefault: String = "com.jeniusLogic.SonnoPremiumAdDefault"
}

//MARK: Google AdMobs
struct AdMobConfig {
    static let AdUnitID: String = "ca-app-pub-9486330364911535/7450167204"
}

//MARK: Ads Ocurrence
struct AdsOcurrence {
    static let PremiumAdOcurrence: Int = 5 //Once every n times
    static let AdMobPresentationOcurrence: Int = 2
}

//MARK:- Colors
let kSonnoColor: UIColor = UIColor(red: 58.0/255.0, green: 57.0/255.0, blue: 57.0/255.0, alpha: 1.0)
let kSonnoBlueColor: UIColor = UIColor(red: 38.0/255.0, green: 77.0/255.0, blue: 113.0/255.0, alpha: 1.0)
let kWakeWellBackgroundColor: UIColor = UIColor(red: 197.0/255.0, green: 197.0/255.0, blue: 197.0/255.0, alpha: 1.0)

//Plist
struct PlistNamesConfig {
    static let SleepWellPlistName = "SleepWell"
    static let WakeWellPlistName = "WakeWell"
    static let SoundsPlist = "Sounds"
    static let PremiumAdPlist = "PremiumAd"
}

//Starting Times
struct StartingTimesConfig {
    static let SleepWellStartingTime = "15 min"
    static let WakeWellStartingTime = "7:30 am"
}

//MARK:- Texts
let kAboutText: String = "Nullam id dolor id nibh ultricies vehicula ut id elit. Nulla vitae elit libero, a pharetra augue. Vestibulum id ligula porta felis euismod semper. Maecenas sed diam eget risus varius blandit sit amet non magna. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Curabitur blandit tempus porttitor. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Maecenas sed diam eget risus varius blandit sit amet non magna. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Donec id elit non mi porta gravida at eget metus. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.Nullam id dolor id nibh ultricies vehicula ut id elit. Nulla vitae elit libero, a pharetra augue. Vestibulum id ligula porta felis euismod semper. Maecenas sed diam eget risus varius blandit sit amet non magna. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Curabitur blandit tempus porttitor. Integer posuere erat a ante venenati."