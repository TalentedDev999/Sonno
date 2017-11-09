//
//  PremiumTableViewCell.swift
//  Sonno
//
//  Created by Lucas Maris on 12/1/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class PremiumTableViewCell: GenericTableViewCell {

    let label = UILabel()
    let subtitle = UILabel()
    
    override func commonInit() {
        
        self.backgroundColor = UIColor.whiteColor()

        label.text = "Go Premium"
        label.textColor = kSonnoBlueColor
        label.customFont(.DisplayRegular, size: 25.0)
        self.contentView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).offset(-15.0)
        }
        
        subtitle.text = "for just 1.99"
        subtitle.textColor = kSonnoBlueColor
        subtitle.customFont(.DisplayLight, size: 19.0)
        self.contentView.addSubview(subtitle)
        subtitle.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).offset(15.0)
        }
    }

}
