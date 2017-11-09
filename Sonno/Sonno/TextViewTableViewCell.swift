//
//  TextViewTableViewCell.swift
//  Sonno
//
//  Created by Lucas Maris on 12/1/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class TextViewTableViewCell: GenericTableViewCell {

    let label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, text: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)

        label.text = text
        label.numberOfLines = 0
        label.customFont(.DisplayLight, size: 14.0)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = kSonnoBlueColor
        self.contentView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(self.contentView).offset(15.0)
            make.bottom.right.equalTo(self.contentView).offset(-15.0)
        }
    }
}
