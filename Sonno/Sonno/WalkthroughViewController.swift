//
//  WalkthroughViewController.swift
//
//  Created by Lucas Maris on 6/20/15.
//  Copyright (c) 2015 Lucas Maris. All rights reserved.
//

import UIKit

protocol WalkthroughViewControllerDelegate: NSObjectProtocol {
    func didDisapperar()
}

class WalkthroughViewController: UIViewController {

    private let cellIdentifier = "tourCell"
    private var collectionView: UICollectionView!
    private var imagesNamesArray: NSArray!
    
    weak var delegate: WalkthroughViewControllerDelegate!
    
    //MARK:- View Lifecycle
    override func loadView() {
        super.loadView()
        let walkthroughtView = WalkthroughView()
        walkthroughtView.backgroundColor = UIColor.clearColor()
        walkthroughtView.delegate = self
        self.view = walkthroughtView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("TourImagesNames", ofType: "plist")
        
        if let plistPath = path {
            imagesNamesArray = NSArray(contentsOfFile: plistPath)
        }

        
        createCollectionView()
        
        self.collectionView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.view is WalkthroughView {
            (self.view as! WalkthroughView).animatePhoneEntrance()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK:- Collection View
    func createCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = TourManager.sharedInstance.getScaledItemSize()
        
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = TourManager.sharedInstance.itemSpacing
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        
        collectionView.registerClass(WalkthroughCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        if self.view is WalkthroughView {
            (self.view as! WalkthroughView).phoneImageView.addSubview(collectionView)
            
            collectionView.snp_makeConstraints { (make) -> Void in
//                if kSCREEN_WIDTH < 350 {
//                    make.centerX.equalTo((self.view as! WalkthroughView).phoneImageView).offset(-2.25)
//                    make.centerY.equalTo((self.view as! WalkthroughView).phoneImageView).offset(-15.75)
//
//                } else {
//                    make.centerX.equalTo((self.view as! WalkthroughView).phoneImageView).offset(-3.0)
//                    make.centerY.equalTo((self.view as! WalkthroughView).phoneImageView).offset(-21.0)
//                }
                make.centerX.equalTo((self.view as! WalkthroughView).phoneImageView).offset(TourManager.sharedInstance.getScaledOffsets().x)
                make.centerY.equalTo((self.view as! WalkthroughView).phoneImageView).offset(TourManager.sharedInstance.getScaledOffsets().y)
                make.size.equalTo(TourManager.sharedInstance.getScaledItemSize())
            }
        }
    }
}

//MARK:- UICollectionView Data Source
extension WalkthroughViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesNamesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! WalkthroughCollectionViewCell
        
        if let imageString = imagesNamesArray[indexPath.row] as? String {
            cell.imageView.image = UIImage(named: imageString)
        }
        
        cell.backgroundColor = UIColor.magentaColor()
        
        return cell
    }
}

//MARK:- UICollectionView Delegate
extension WalkthroughViewController: UICollectionViewDelegate {}

//MARK:- Walkthrought Delegate
extension WalkthroughViewController: WalkthroughDelegate {

    func donePressed() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(true, forKey: "hasSeenIntro")
        userDefault.synchronize()
        
        if self.delegate != nil {
            self.delegate.didDisapperar()
            self.dismissViewControllerAnimated(false, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func activeScroll(xOffset: CGFloat) {
        self.collectionView.contentOffset = CGPoint(x: xOffset/TourManager.sharedInstance.getScaleFactor(), y: 0)
    }
    
    func scrollCollectionView(xOffset: CGFloat) {
        
        let itemIndex = xOffset/kScreenWidth
        
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: Int(itemIndex), inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
}
