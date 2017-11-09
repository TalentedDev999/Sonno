//
//  ContactTableViewCell.swift
//  Sonno
//
//  Created by Lucas Maris on 12/14/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

protocol ContactTableViewCellDelegate: class {
    func openWebsiteWithURL(websiteString: String)
}

class ContactTableViewCell: GenericTableViewCell {

    weak var delegate: ContactTableViewCellDelegate!
    
    override func commonInit() {
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        
        let sonnoButton = UIButton()
        sonnoButton.setTitle("www.sonnoapp.com", forState: UIControlState.Normal)
        sonnoButton.setTitleColor(kSonnoBlueColor, forState: UIControlState.Normal)
        sonnoButton.underlineButton()
        sonnoButton.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(sonnoButton)
        sonnoButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView).offset(15.0)
            make.centerX.equalTo(self.contentView)
        }
        
        let designLabel = UILabel()
        designLabel.customFont(.DisplayLight, size: 14.0)
        designLabel.text = "Design and Development by:"
        designLabel.textColor = kSonnoBlueColor
        self.contentView.addSubview(designLabel)
        designLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(sonnoButton.snp_bottom).offset(10.0)
        }
        
        let jeniusLogicImageView = UIImageView(image: UIImage(assetIdentifier: .JeniusLogicLogo))
        self.contentView.addSubview(jeniusLogicImageView)
        jeniusLogicImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(designLabel.snp_bottom).offset(15.0)
        }
        
        let jeniusLogicButton = UIButton()
        jeniusLogicButton.setTitle("www.jeniuslogic.com", forState: UIControlState.Normal)
        jeniusLogicButton.setTitleColor(kSonnoBlueColor, forState: UIControlState.Normal)
        jeniusLogicButton.underlineButton()
        jeniusLogicButton.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(jeniusLogicButton)
        jeniusLogicButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(jeniusLogicImageView.snp_bottom).offset(15.0)
            make.bottom.equalTo(self.contentView).offset(-15.0)
            make.centerX.equalTo(self.contentView)
        }
    }
    
    func buttonPressed(sender: UIButton) {
        self.delegate.openWebsiteWithURL(sender.titleLabel?.text ?? "www.jeniuslogic.com")
    }
}
