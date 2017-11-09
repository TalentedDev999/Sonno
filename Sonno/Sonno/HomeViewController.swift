//
//  HomeViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import Armchair
import GoogleMobileAds

class HomeViewController: GenericViewController {
    
    //MARK: View Lifecycle
    override func loadView() {
        super.loadView()
        let homeView = HomeView()
        homeView.delegate = self
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarTitle(title: "sonno")
        
        addInterpolationMovement()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barTintColor = kSonnoColor
        
        if !PurchaseManager.sharedInstance.isPremium {
            showAd()   
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Ads
    func showAd() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //Get the amount of times you already been in this screen
        guard let currentOcurrence = userDefaults.objectForKey(UserDefaultsConfig.PremiumAdOcurrenceDefault) as? Int else {
            userDefaults.setInteger(1, forKey: UserDefaultsConfig.PremiumAdOcurrenceDefault)
            userDefaults.synchronize()
            return
        }
        
        //If its conforms our ocurrence (once every 5 times)
        if currentOcurrence % AdsOcurrence.PremiumAdOcurrence == 0 {
            
            //Show the premium ad
            let navigationController = UINavigationController(rootViewController: PremiumAdTableViewController(plistName: PlistNamesConfig.PremiumAdPlist))
            navigationController.addNavigationBarTitle(title: "sonno")
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
        
        //Add an ocurrence of appearence on this screen
        userDefaults.setInteger(currentOcurrence + 1, forKey: UserDefaultsConfig.PremiumAdOcurrenceDefault)
        userDefaults.synchronize()
    }
    
    func addNavigationBarTitle(title title: String) {
        let label = UILabel()
        label.customFont(.DisplayUltraLight, size: kNavigationFontSize)
        label.text = title
        label.textColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.navigationController!.navigationBar.snp_center)
        }
    }
    
    func addInterpolationMovement() {
        
        if (self.view is HomeView) {
            
            // Add both effects to your view
            (self.view as! HomeView).backgroundImageView.addBackgroundInterpolationMovement()
            
            //Items Effect
            let verticalItemsMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                type: .TiltAlongVerticalAxis)
            verticalItemsMotionEffect.minimumRelativeValue = -10
            verticalItemsMotionEffect.maximumRelativeValue = 10
            
            // Set horizontal effect
            let horizontalItemsMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                type: .TiltAlongHorizontalAxis)
            horizontalItemsMotionEffect.minimumRelativeValue = -10
            horizontalItemsMotionEffect.maximumRelativeValue = 10
            
            // Create group to combine both
            let itemGroup = UIMotionEffectGroup()
            itemGroup.motionEffects = [horizontalItemsMotionEffect, verticalItemsMotionEffect]
            
            (self.view as! HomeView).titleLabel.addMotionEffect(itemGroup)
            (self.view as! HomeView).moonButton.addMotionEffect(itemGroup)
            (self.view as! HomeView).sunriseButton.addMotionEffect(itemGroup)
            (self.view as! HomeView).settingsButton.addMotionEffect(itemGroup)
            (self.view as! HomeView).musicButton.addMotionEffect(itemGroup)
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func setupSleep() {
        self.navigationController?.showViewController(SetupPageControllerViewController(), sender: nil)
    }
    
    func setupWake() {
        
        let setupPageController = SetupPageControllerViewController()
        setupPageController.selectedIndex = 1
        self.navigationController?.showViewController(setupPageController, sender: nil)
    }
    
    func sendToAudio() {
        self.navigationController?.showViewController(AudioTableViewController(), sender: nil)
    }
    
    func sendToSettings() {
        self.navigationController?.showViewController(SettingsTableViewController(), sender: nil)
    }
}
