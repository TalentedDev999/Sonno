//
//  TimersTableViewCell.swift
//  Sonno
//
//  Created by Lucas Maris on 12/20/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class TimersTableViewCell: GenericTableViewCell {
    
    var titleLabel: UILabel!
    let mediaTypeTitleTimeView = MediaTypeTitleTimeView()
    let backgroundImageView = UIImageView()

    override func commonInit() {
        
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.clipsToBounds = true
        self.contentView.addSubview(backgroundImageView)
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.contentView)
        }
        
        titleLabel = UIManager.sharedInstance.sonnoLabel(25.0)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(15.0)
        }
        
        self.contentView.addSubview(mediaTypeTitleTimeView)
        mediaTypeTitleTimeView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-5.0)
        }
    }

    func setWithTimer(timer: TimerSetup) {
        switch timer.type! {
        case .Sleep:
            backgroundImageView.image = UIImage(assetIdentifier: .Background)
            titleLabel.text = "Sleep Well"
            mediaTypeTitleTimeView.timeLabel.text = "is set for \(timer.minutesTimer ?? 15) minutes"
        case .Wake:
            backgroundImageView.image = UIImage(assetIdentifier: .WakeWellBackground)
            titleLabel.text = "Wake Well"
            mediaTypeTitleTimeView.timeLabel.text = "begins at \(UtilitiesManager.sharedInstance.formatter.stringFromDate(timer.wakeTime!))"
        }
        
        mediaTypeTitleTimeView.mediaTypeLabel.text = timer.playlist == nil ? "Sound" : "Playlist"
        mediaTypeTitleTimeView.mediaTitleLabel.text = timer.playlist?.title ?? timer.mediaItem?.title ?? ""
    }
}
