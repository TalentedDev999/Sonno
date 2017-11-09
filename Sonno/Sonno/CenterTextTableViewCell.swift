//
//  CenterTextTableViewCell.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class CenterTextTableViewCell: GenericTableViewCell {

    lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.customFont(.DisplayLight, size: 24.0)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    private var subtitleLabel: UILabel?

    override func commonInit() {
        
        self.contentView.addSubview(cellLabel)
        cellLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.contentView)
        }
    }
    
    func resetCell() {
        cellLabel.customFont(.DisplayLight, size: 24.0)
    }
    
    func selectedWithTitle(text: String) {
        cellLabel.customFont(.DisplayRegular, size: 25.0)
        cellLabel.text = text
    }
    
    func socialStyle() {
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        
        cellLabel.textColor = kSonnoBlueColor
        
        cellLabel.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView).offset(15.0)
            make.bottom.equalTo(self.contentView).offset(-15.0)
            make.centerX.equalTo(self.contentView)
        }
        
        cellLabel.customFont(.DisplayRegular, size: 15.0)
    }
}
