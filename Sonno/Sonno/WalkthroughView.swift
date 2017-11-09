//
//  WalkthroughView.swift
//
//  Created by Lucas Maris on 6/20/15.
//  Copyright (c) 2015 Lucas Maris. All rights reserved.
//

import UIKit
import Spring

protocol WalkthroughDelegate: NSObjectProtocol {
    func donePressed()
    func scrollCollectionView(xOffset: CGFloat)
    func activeScroll(xOffset: CGFloat)
}

class WalkthroughView: UIView, UIScrollViewDelegate {
    
    private var scrollView: UIScrollView!
    private var circleArray = [UIImageView]()
    private let screensCount = 5
    private var textsArray: NSArray!
    let button = UIButton()
    
    //Arrows
    let leftArrow = UIButton()
    let rightArrow = UIButton()
    
    let phoneImageView = SpringImageView(image: TourManager.sharedInstance.getImage())
    weak var delegate: WalkthroughDelegate!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.magentaColor()
        
        //Get texts
        let path = NSBundle.mainBundle().pathForResource("TourTexts", ofType: "plist")
        
        if let plistPath = path {
            textsArray = NSArray(contentsOfFile: plistPath)
        }
        
        let imageView = UIImageView(image: UIImage(assetIdentifier: .Background))
        imageView.addBackgroundInterpolationMovement()
        self.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).offset(UIEdgeInsets(top: -10, left: -10, bottom: 10, right: 10))
        }
        
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(kScreenWidth * CGFloat(screensCount), 0)
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.clearColor()
        self.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        
        phoneImageView.addForegroundInterpolationMovement()
        phoneImageView.clipsToBounds = true
        phoneImageView.alpha = 0.0
        self.addSubview(phoneImageView)
        phoneImageView.snp_makeConstraints { (make) -> Void in
            
            //is iPhone 5 or 4
//            if kSCREEN_WIDTH < 350 {
//                make.size.equalTo(CGSizeMake(214.5, 372.75))
//                make.centerX.equalTo(self)
//                make.bottom.equalTo(self).offset(-25.0)
//            } else {
//                make.bottom.centerX.equalTo(self)
//                make.height.equalTo(497)
//            }
            
            make.size.equalTo(CGSizeMake(TourManager.sharedInstance.getiphoneImageSizeForiPhone().width, TourManager.sharedInstance.getiphoneImageSizeForiPhone().height))
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-25.0)
        }
        
        for value in 0...screensCount - 1 {
            
            //Add labels
            let label = UILabel()
            label.addForegroundInterpolationMovement()
            label.textColor = UIColor.whiteColor()
            label.text = (textsArray[value] as! String)
            label.textAlignment = NSTextAlignment.Center
            label.customFont(.DisplayLight, size: 17.0 * TourManager.sharedInstance.sizeScale)
            label.numberOfLines = 0
            scrollView.addSubview(label)
            label.snp_makeConstraints(closure: { (make) -> Void in
                make.centerX.equalTo(scrollView).offset(kScreenWidth * CGFloat(value))
                make.top.equalTo(scrollView).offset(25.0)
                make.width.equalTo(kScreenWidth * 0.75)
                make.bottom.equalTo(phoneImageView.snp_top).offset(-15.0)
            })
            
            //Add indicator points
            let circle = UIImageView(image: UIImage(named: value == 0 ? "filledCircle" : "circle"))
            circle.addForegroundInterpolationMovement()
            circleArray.append(circle)
            self.addSubview(circle)
            circle.snp_makeConstraints(closure: { (make) -> Void in
                make.centerX.equalTo(self).offset(-65.0 + 20 * CGFloat(value))
                make.bottom.equalTo(self).offset(-20.0)
            })
        }
        
        //Skip/Done button
        button.addForegroundInterpolationMovement()
        button.setTitle("Skip", forState: UIControlState.Normal)
        button.titleLabel?.customFont(.DisplayUltraLight, size: 24.0)
        button.addTarget(self, action: "buttonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-10.0)
            make.right.equalTo(self).offset(-20.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:- ScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.delegate.activeScroll(scrollView.contentOffset.x)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.delegate.scrollCollectionView(scrollView.contentOffset.x)
        
        for circle in circleArray {
            circle.image = UIImage(named: "circle")
        }
        let newValue = Int(scrollView.contentOffset.x/kScreenWidth)
        circleArray[newValue].image = UIImage(named: "filledCircle")
        
        if newValue == screensCount - 1 {
            button.setTitle("Done", forState: UIControlState.Normal)
        } else {
            button.setTitle("Skip", forState: UIControlState.Normal)
        }
    }
    
    //Button Action
    func buttonPressed() {
        
        dispatch_async(dispatch_get_main_queue(),{
            UIView.animateWithDuration(0.33,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    self.scrollView.alpha = 0.0
                    self.phoneImageView.alpha = 0.0
                }) { (finished) -> Void in
                    if self.delegate != nil {
                        self.delegate.donePressed()
                    }
            }
        })
    }
    
    //ArrowPressed
    func arrowPressed(sender: UIButton) {
        if sender.tag == 0 {
            
            UIView.animateWithDuration(0.33,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - kScreenWidth, 0)
                },
                completion: { (finished) -> Void in
                self.scrollViewDidEndDecelerating(self.scrollView)
            })
            
        } else {
            UIView.animateWithDuration(0.33,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + kScreenWidth, 0)
                },
                completion: { (finished) -> Void in
                    self.scrollViewDidEndDecelerating(self.scrollView)
            })
        }

    }
    
    //MARK: Animations
    func animatePhoneEntrance() {
        
        phoneImageView.animation = "zoomIn"
        phoneImageView.curve = "spring"
        phoneImageView.animate()
    }
}
