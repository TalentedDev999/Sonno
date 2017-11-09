//
//  AdManager.swift
//  Sonno
//
//  Created by Lucas Maris on 12/17/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdManager: NSObject {

    static let sharedInstance = AdManager()
    
    var interstitial: GADInterstitial!
    
    func createAndLoadInterstitial() {
        let newInterstitial = GADInterstitial(adUnitID: AdMobConfig.AdUnitID)
        newInterstitial.delegate = self
        
        //Request
        let request = GADRequest()
        request.testDevices = ["8f4574cb1dde45d04932d2fed2a33860"]
        newInterstitial.loadRequest(request)

        self.interstitial = newInterstitial
    }
    
    func presentAdd(onViewController: UIViewController) {
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(onViewController)
        }
    }
}

extension AdManager: GADInterstitialDelegate {
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        createAndLoadInterstitial()
    }
}
