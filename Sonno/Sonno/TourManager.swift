//
//  TourManager.swift
//  PlaySportsApp
//
//  Created by Lucas Maris on 10/22/15.
//  Copyright © 2015 Lucas Maris. All rights reserved.
//

import UIKit

class TourManager: NSObject {

    static let sharedInstance = TourManager()
    
    let itemSpacing: CGFloat = 7.5
    
    let itemSize = CGSize(width: 180.0, height: 320.0)
    
    let offsets = CGPoint(x: -3.0, y: -21.0)
    
    let iphoneImageSize = CGSize(width: 572/2, height: 994/2)
    
    let sizeScale = (kScreenWidth/375)/(kScreenHeight < 500 ? 1.25 : 1)
    
    func getImage() -> UIImage {
        return UIImage(assetIdentifier: UIImage.AssetIdentifier.iPhone)
    }
    
    func getScaleFactor() -> CGFloat {
        let scaledItemSize = getScaledItemSize()
        return kScreenWidth/(scaledItemSize.width + itemSpacing)
    }
    
    func getScaledItemSize() -> CGSize {
        return CGSize(width: itemSize.width * sizeScale, height: itemSize.height * sizeScale)
    }
    
    func getiphoneImageSizeForiPhone() -> CGSize {
       return CGSize(width: iphoneImageSize.width * sizeScale, height: iphoneImageSize.height * sizeScale)
    }
    
    func getScaledOffsets() -> CGPoint {
        return CGPoint(x: offsets.x * sizeScale, y: offsets.y * sizeScale)
    }
}
