//
//  AppDelegate.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Armchair
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //Enable Crashlytics
        Fabric.with([Crashlytics.self])
        
        //NavigationBar
        navigationBarUI()
        
        //Status Bar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        //AdMob - Setup
        AdManager.sharedInstance.createAndLoadInterstitial()
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        
        //Get In-App Purchases
        PurchaseManager.sharedInstance
        
        let pageControllerAppearance = UIPageControl.appearance()
        pageControllerAppearance.backgroundColor = UIColor.clearColor()
        
        let navigationController = UINavigationController(rootViewController: AnimationViewController())
        navigationController.navigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: 3D Touch
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let type = shortcutItem.type
        
        switch type {
        case "com.jeniusLogic.sonno.wakeWell":
            print("Send to wake well")
        case "com.jeniusLogic.sonno.sleepWell":
            print("Send to sleep Well")
        default:
            print("Send to default")
        }
    }

    //MARK: Navigation UI
    func navigationBarUI() {
        
        let appearance = UINavigationBar.appearance()
        
        appearance.barTintColor = kSonnoColor
        appearance.tintColor = UIColor.whiteColor()
        appearance.translucent = false
        appearance.shadowImage = UIImage()
        appearance.setBackgroundImage(UIImage(assetIdentifier: .NavigationBackground), forBarMetrics: UIBarMetrics.Default)
        
        let titleUIDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: kNavigationFontSize)!]
        
        appearance.titleTextAttributes = titleUIDict as? [String : AnyObject]
    }
}

//MARK: Armchair
extension AppDelegate {
    
    override class func initialize() {
        AppDelegate.setupArmchair()
    }
    
    class func setupArmchair() {
        // Normally, all the setup would be here.
        // But, because we are presenting a few different setups in the example,
        // The config will be in the view controllers
        //	 Armchair.appID("408981381") // Pages
        //
        // It is always best to load Armchair as early as possible
        // because it needs to receive application life-cycle notifications
        //
        // NOTE: The appID call always has to go before any other Armchair calls
        Armchair.appID(AppStoreConfig.AppID)
        Armchair.debugEnabled(true)
        Armchair.shouldPromptIfRated(true)
    }
}
