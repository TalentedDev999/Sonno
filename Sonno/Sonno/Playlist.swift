//
//  PlayList.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class Playlist: NSObject, NSCoding {
    
    var id: String!
    var title: String!
    dynamic var items = [MediaItem]()
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.id = decoder.decodeObjectForKey("id") as! String
        self.title = decoder.decodeObjectForKey("title") as! String
        self.items = decoder.decodeObjectForKey("items") as! [MediaItem]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(items, forKey: "items")
    }
    
    override init() {
        super.init()
    }
    
    init(id: String, items: [MediaItem]) {
        self.id = id
        self.items = items
        super.init()
    }
    
    func save() {
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/playlist_\(self.id).bin")
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        data.writeToFile(filename, atomically: true)
    }

    func delete() {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(NSHomeDirectory().stringByAppendingString("/Documents/playlist_\(self.id).bin"))
        } catch {
            print(error)
        }
    }
}
