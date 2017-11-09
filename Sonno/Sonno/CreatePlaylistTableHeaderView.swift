//
//  CreatePlaylistTableHeaderView.swift
//  Sonno
//
//  Created by Lucas Maris on 11/25/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

protocol CreatePlaylistTableHeaderViewDelegate: NSObjectProtocol {
    func setPlaylistName(name: String)
}

class CreatePlaylistTableHeaderView: GenericView {

    let textField = UITextField()
    
    weak var delegate: CreatePlaylistTableHeaderViewDelegate!
    
    override func commonInit() {
        let label = UIManager.sharedInstance.sonnoLabel(16.0)
        label.text = "Playlist name"
        label.customFont(.DisplayRegular, size: 16.0)
        self.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(15.0)
            make.bottom.equalTo(self)
        }

        textField.delegate = self
        textField.textColor = UIColor.whiteColor()
        textField.customFont(.DisplayRegular, size: 16.0)
        textField.textAlignment = NSTextAlignment.Right
        textField.returnKeyType = UIReturnKeyType.Done
        textField.addTarget(self, action: "textFieldChanged", forControlEvents: UIControlEvents.EditingChanged)
        self.addSubview(textField)
        textField.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-15.0)
            make.bottom.equalTo(self)
            make.width.equalTo(kScreenWidth * 0.6)
        }
    }
    
    func textFieldChanged() {
        guard let string = textField.text else {
            return
        }
        
        self.delegate.setPlaylistName(string)
    }
}

extension CreatePlaylistTableHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
