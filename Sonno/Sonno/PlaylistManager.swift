//
//  PlaylistManager.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class PlaylistManager: NSObject {
    
    static let sharedInstance = PlaylistManager()
    var playlists = [Playlist]()
    
    func getSavedPlaylists() {
        
        playlists = [Playlist]()
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        guard let value = userDefault.valueForKey(kPlaylistCountKey) as? Int else {
            return
        }
        
        for index in 0...value {

            //Fetch Playlists
            if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/playlist_\(index).bin")) {
                let unarchivePlaylist = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Playlist?
                if let unwrappedPlaylist = unarchivePlaylist {
                    playlists.append(unwrappedPlaylist)
                }
            }
        }
    }
    
    func clearPlaylistsCache() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        guard let value = userDefault.valueForKey(kPlaylistCountKey) as? Int else {
            return
        }
        
        for index in 0...value {
            
            //Fetch Playlists
            if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/playlist_\(index).bin")) {
                let unarchivePlaylist = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Playlist?
                if let unwrappedPlaylist = unarchivePlaylist {
                    self.deletePlaylist(unwrappedPlaylist)
                }
            }
        }
        
        userDefault.setValue(0, forKey: kPlaylistCountKey)
        userDefault.synchronize()
    }
    
    func deletePlaylist(playlist: Playlist) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(NSHomeDirectory().stringByAppendingString("/Documents/playlist_\(playlist.id).bin"))
        } catch {
            print(error)
        }
    }
}
