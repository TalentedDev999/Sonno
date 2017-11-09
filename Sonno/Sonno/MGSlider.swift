//
//  MGSlider.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class MGSlider: UISlider {
    
    private struct Config {
        static let sliderNewHeight: CGFloat = 10.0
    }
    
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: CGPoint(x: bounds.origin.x, y: bounds.origin.y + Config.sliderNewHeight/2), size: CGSize(width: bounds.size.width, height: Config.sliderNewHeight))
        super.trackRectForBounds(customBounds)
        return customBounds
    }
}
