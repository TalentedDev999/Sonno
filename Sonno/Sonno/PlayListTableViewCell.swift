//
//  PlayListTableViewCell.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import Spring

class PlayListTableViewCell: GenericTableViewCell {
    
    lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.customFont(.DisplayRegular, size: 16.0)
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.customFont(.DisplayRegular, size: 16.0)
        return label
    }()
    
    lazy var songsCount: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.customFont(.DisplayRegular, size: 16.0)
        return label
    }()
    
    lazy var audioActionButton: SpringButton = {
        let button = SpringButton()
        button.setImage(UIImage(assetIdentifier: .PlayIcon), forState: UIControlState.Normal)
        button.setImage(UIImage(assetIdentifier: .StopIcon), forState: UIControlState.Selected)
        button.userInteractionEnabled = false //Fallthrough touches onto the cell
        return button
    }()

    override func commonInit() {
        
        self.backgroundColor = UIColor.clearColor()

        
        self.contentView.addSubview(numberLabel)
        numberLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(self.contentView).offset(15.0)
        }
        
        self.contentView.addSubview(cellLabel)
        cellLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(numberLabel.snp_right).offset(15.0)
            make.width.equalTo(kScreenWidth * 0.75)
        }
        
        self.contentView.addSubview(songsCount)
        songsCount.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
            make.right.equalTo(self.contentView).offset(-15.0)
        }
    }
    
    func addAudioIcon() {
        self.addSubview(audioActionButton)
        audioActionButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.contentView).offset(-15.0)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    //Audio action
    func animateButtonChange() {
        
        audioActionButton.scaleX = 0.0
        audioActionButton.scaleY = 0.0
        audioActionButton.duration = 0.5
        audioActionButton.animate()

        audioActionButton.selected = !audioActionButton.selected
    }
}
