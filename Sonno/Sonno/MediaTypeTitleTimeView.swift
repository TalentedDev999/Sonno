//
//  MediaTypeTitleTimeView.swift
//  Sonno
//
//  Created by Lucas Maris on 12/20/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class MediaTypeTitleTimeView: GenericView {

    var mediaTypeLabel: UILabel!
    var mediaTitleLabel: UILabel!
    var timeLabel: UILabel!
    
    override func commonInit() {
        
        mediaTypeLabel = UIManager.sharedInstance.sonnoLabel(15.0)
        self.addSubview(mediaTypeLabel)
        mediaTypeLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(2.0)
        }
        
        mediaTitleLabel = UILabel()
        mediaTitleLabel.customFont(.DisplayHeavy, size: 18.0)
        mediaTitleLabel.textColor = UIColor.whiteColor()
        self.addSubview(mediaTitleLabel)
        mediaTitleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(10.0)
            make.bottom.equalTo(self).offset(-10.0)
            make.left.equalTo(mediaTypeLabel.snp_right).offset(5.0)
        }
        
        timeLabel = UIManager.sharedInstance.sonnoLabel(15.0)
        self.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(mediaTitleLabel)
            make.left.equalTo(mediaTitleLabel.snp_right).offset(5.0)
            make.right.equalTo(self).offset(-2.0)
        }
    }
}
