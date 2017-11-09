//
//  SavedPlaylistTableHeaderView.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class SavedPlaylistTableHeaderView: GenericView {

    override func commonInit() {
        
        self.backgroundColor = UIColor.clearColor()
        
        let numberLabel = UIManager.sharedInstance.sonnoLabel(16.0)
        numberLabel.text = "№"
        self.addSubview(numberLabel)
        numberLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(15.0)
            make.centerY.equalTo(self)
        }
        
        let titleLabel = UIManager.sharedInstance.sonnoLabel(16.0)
        titleLabel.text = "Playlist name"
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(numberLabel.snp_right).offset(10.0)
            make.centerY.equalTo(self)
        }
        
        let songCountLabel = UIManager.sharedInstance.sonnoLabel(16.0)
        songCountLabel.text = "songs"
        self.addSubview(songCountLabel)
        songCountLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-15.0)
            make.centerY.equalTo(self)
        }
    }
}
