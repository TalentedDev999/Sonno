//
//  MediaManager.swift
//  Sonno
//
//  Created by Lucas Maris on 12/10/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class MediaManager: NSObject {

    static let sharedInstance = MediaManager()
    
    var items = [NSObject]()
    
    override init() {
        super.init()
    }

    func getAllMedia() {
        
        PlaylistManager.sharedInstance.getSavedPlaylists()
        items.appendContentsOf(PlaylistManager.sharedInstance.playlists as [NSObject])
        getSounds()
    }
    
    private func getSounds() {
        
        if let path = NSBundle.mainBundle().pathForResource(PlistNamesConfig.SoundsPlist, ofType: "plist") {
            let dictionaryArray = NSArray(contentsOfFile: path)!
            
            for dictionary in dictionaryArray {
                let soundItem = MediaItem(dictionary: dictionary as! Dictionary<String, AnyObject>)
                //Add to our array
                items.append(soundItem)
            }
        }
    }
}
