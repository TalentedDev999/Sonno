//
//  CustomTableHeaderView.swift
//  Sonno
//
//  Created by Lucas Maris on 12/1/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class CustomTableHeaderView: GenericView {
    
    lazy var label = UIManager.sharedInstance.sonnoLabel(18.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(title: String) {
        
        //Start at 10 for parallax effect
        super.init(frame: CGRectMake(0, 0, kScreenWidth, 60.0))
        
        self.backgroundColor = UIColor(hex: "13293D").colorWithAlphaComponent(0.85)
        
        label.text = title
        label.customFont(.DisplayRegular, size: 16.0)
        self.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(30.0)
            make.centerY.equalTo(self).offset(10.0)
        }
    }
}
