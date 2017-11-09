//
//  SetupPageControllerViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 12/8/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class SetupPageControllerViewController: GenericViewController {
    
    
    //MARK: Config
    private struct SetupPageControllerConfig {
        static let NumberOfPages = 3
        static let HorizontalScrollSize: CGFloat = kScreenWidth * CGFloat(NumberOfPages)
        static let VerticalScrollSize: CGFloat = kScreenHeight - kNavigationAndStatusBarHeight
    }
    
    //MARK: Properties
    private var scrollView: UIScrollView! {
        didSet {
            
            scrollView.delegate = self
            
            scrollView.contentSize = CGSizeMake(SetupPageControllerConfig.HorizontalScrollSize, 0)
            scrollView.backgroundColor = UIColor.blueColor()
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.bounces = false
            scrollView.pagingEnabled = true
            
            setupScrollOffset()
        }
    }
    
    private var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages = SetupPageControllerConfig.NumberOfPages
            setupPageControl()
        }
    }
    
    //PageControl Images
    private let firstPageImageView = UIImageView(image: UIImage(assetIdentifier: .FirstPage))
    private let secondPageImageView = UIImageView(image: UIImage(assetIdentifier: .SecondPage))
    private let thirdPageImageView = UIImageView(image: UIImage(assetIdentifier: .ThirdPage))

    private let viewControllers = [SetupTableViewController(plistName: PlistNamesConfig.SleepWellPlistName, type: SetupType(startTime: StartingTimesConfig.SleepWellStartingTime, option: SetupOption.Sleep)), SetupTableViewController(plistName: PlistNamesConfig.WakeWellPlistName, type: SetupType(startTime: StartingTimesConfig.WakeWellStartingTime, option: SetupOption.Wake)), ConfirmationViewController()]
    
    private var wakeWellNavigationImage = UIImageView(frame: CGRect(x: kScreenWidth, y: -20.0, width: kScreenWidth, height: 64.0))
    
    var selectedIndex: Int?
    
    //Ads 
    private var showedAd = false
    
    //MARK: Init and Dealloc
    deinit {
        wakeWellNavigationImage.removeFromSuperview()
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
//        pageControl = UIPageControl()
//        self.view.addSubview(pageControl)
//        pageControl.snp_makeConstraints { (make) -> Void in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(self.view)
//        }
        

        self.view.addSubview(firstPageImageView)
        firstPageImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-10.0)
        }
        
        secondPageImageView.alpha = 0.0
        self.view.addSubview(secondPageImageView)
        secondPageImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-10.0)
        }
        
        thirdPageImageView.alpha = 0.0
        self.view.addSubview(thirdPageImageView)
        thirdPageImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-10.0)
        }
        
        //Create Controllers
        for (index, controller) in viewControllers.enumerate() {
            self.addViewControllerAtPosition(viewController: controller, index: index)
        }
        
        //Add wake well image
        wakeWellNavigationImage.image = UIImage(assetIdentifier: .WakeWellNavigationBackground)
        self.navigationController?.navigationBar.addSubview(wakeWellNavigationImage)
        
        self.navigationController?.bringTitleToFront()
        
        //Add delegates
        if let confirmationController = viewControllers[2] as? ConfirmationViewController {
        
            if let sleepSetup = viewControllers[0] as? SetupTableViewController {
                sleepSetup.setupDelegate = confirmationController
            }
            
            if let wakeSetup = viewControllers[1] as? SetupTableViewController {
                wakeSetup.setupDelegate = confirmationController
            }
        }
        
        //Notification for non premium
        if !PurchaseManager.sharedInstance.isPremium {
            let defaultNotificationCenter = NSNotificationCenter.defaultCenter()
            defaultNotificationCenter.addObserver(self, selector: Selector("presentPremiumAd"), name: NotificationsConfig.PresentPremiumAd, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        wakeWellNavigationImage.alpha = 0.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        wakeWellNavigationImage.alpha = 1.0
    }
    
    //MARK: Setup Methods
    func setupSelectedIndex(index: Int) {
        self.pageControl.currentPage = index
        
    }
    
    private func setupPageControl() {
        pageControl.currentPage = selectedIndex ?? 0
    }
    
    private func setupScrollOffset() {
        scrollView.setContentOffset(CGPoint(x: kScreenWidth * CGFloat(selectedIndex ?? 0), y: 0), animated: false)
    }
    
    //MARK: Extra
    private func addViewControllerAtPosition(viewController controller: UIViewController, index: Int) {
       
        self.addChildViewController(controller)
        controller.didMoveToParentViewController(self)
        self.scrollView.addSubview(controller.view)
        
        controller.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.scrollView)
            make.left.equalTo(self.scrollView).offset(kScreenWidth * CGFloat(index))
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScreenHeight - kNavigationAndStatusBarHeight))
        }
    }
    
    //MARK: Ads
    func presentPremiumAd() {
        let premiumNavigation = UINavigationController(rootViewController: PremiumAdTableViewController(plistName: PlistNamesConfig.PremiumAdPlist))
        premiumNavigation.addNavigationBarTitle(title: "sonno")
        self.navigationController?.presentViewController(premiumNavigation, animated: true, completion: nil)
    }
    
    //MARK: Gesture - Shake
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            print("SHAKED!")
            
            //TODO: Reset setups
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NotificationsConfig.ShakeToRestart, object: nil))
        }
    }
}

//MARK: UIScrollViewDelegate
extension SetupPageControllerViewController: UIScrollViewDelegate {
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        
//        //Get scrolled value
//        let xScroll = scrollView.contentOffset.x
//        let newValue = xScroll/kScreenWidth
//        
//        //Set the new scroll page on the UIPageControl
//        self.pageControl.currentPage = Int(newValue)
//        
//        //Change dots color 
//        if newValue == 2 {
//            pageControl.pageIndicatorTintColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
//            pageControl.currentPageIndicatorTintColor = kSonnoBlueColor
//        } else {
//            pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
//            pageControl.pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
//        }
//    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let xScroll = scrollView.contentOffset.x
        wakeWellNavigationImage.frame = CGRect(x: kScreenWidth - xScroll , y: -20.0, width: kScreenWidth, height: 64.0)
    
    
        //Animate Page Image Dots
        if xScroll/kScreenWidth <= 1.0 {
            firstPageImageView.alpha = 1 - xScroll/kScreenWidth
            secondPageImageView.alpha = xScroll/kScreenWidth
        } else {
            secondPageImageView.alpha = 2 - xScroll/kScreenWidth
            thirdPageImageView.alpha = xScroll/kScreenWidth - 1
        }
        
        if !PurchaseManager.sharedInstance.isPremium {
            if xScroll == kScreenWidth * 2 {
                if !showedAd {
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    
                    guard let currentOcurrence = userDefaults.objectForKey(UserDefaultsConfig.AdMobOcurrenceDefault) as? Int else {
                        userDefaults.setInteger(1, forKey: UserDefaultsConfig.AdMobOcurrenceDefault)
                        userDefaults.synchronize()
                        return
                    }
                    
                    if currentOcurrence % AdsOcurrence.AdMobPresentationOcurrence == 0 {
                        AdManager.sharedInstance.presentAdd(self)
                        showedAd = true
                    }
                    
                    userDefaults.setInteger(currentOcurrence + 1, forKey: UserDefaultsConfig.AdMobOcurrenceDefault)
                    userDefaults.synchronize()
                }
            }
        }
    }
}
