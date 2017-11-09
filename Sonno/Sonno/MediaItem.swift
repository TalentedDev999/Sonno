//
//  MediaItem.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

//Enum for songs names -> TypeSafe
enum SoundName: String {
    case Birds = "birds"
    case Ocean = "ocean"
    case Morning = "morning"
}

enum MediaType: Int {
    case Sound = 0,
    Playlist
    
    func getTypeName() -> String {
        return self == .Sound ? "Sound" : "Playlist"
    }
}

class MediaItem: NSObject, NSCoding {
    
    var id: Int?
    var title: String?
    var fileURL: String?
    var mpMediaItem: MPMediaItem?
    var type: MediaType
    
    
    //MARK:- NSCoding init
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObjectForKey("id") as? Int
        self.title = decoder.decodeObjectForKey("title") as? String
        self.fileURL = decoder.decodeObjectForKey("fileURL") as? String
        self.mpMediaItem = decoder.decodeObjectForKey("mpMediaItem") as? MPMediaItem
        self.type = MediaType(rawValue: decoder.decodeObjectForKey("type") as! Int)!
        
        super.init()
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(fileURL, forKey: "fileURL")
        aCoder.encodeObject(mpMediaItem, forKey: "mpMediaItem")
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
    }
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        self.id = dictionary["id"] as? Int
        self.title = dictionary["title"] as? String
        self.fileURL = dictionary["fileURL"] as? String
        self.type = .Sound
        super.init()
    }

    init(mpMediaItem: MPMediaItem!) {
        
        self.mpMediaItem = mpMediaItem
        self.type = .Playlist
        super.init()
    }
    
    var displayTitle: String {
        switch type {
        case MediaType.Sound:
            return title ?? ""
        case MediaType.Playlist:
           
            guard let item = mpMediaItem else {
                return ""
            }
            
            guard let artist = item.artist, let songTitle = item.title else {
                return ""
            }
            
            return "\(artist) - \(songTitle)"
        }
    }
}
