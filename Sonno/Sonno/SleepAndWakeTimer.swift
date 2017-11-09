//
//  SleepAndWakeTimer.swift
//  Sonno
//
//  Created by Lucas Maris on 12/18/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import Foundation

struct TimerSetup {
    var type: SetupOption?
    var mediaItem: MediaItem?
    var playlist: Playlist?
    var wakeTime: NSDate?
    var minutesTimer: Int?
    var angle: Int?
    var volume: Float
    
    init() {
        type = nil
        mediaItem = nil
        playlist = nil
        wakeTime = nil
        minutesTimer = nil
        angle = nil
        volume = 0.5
    }
    
    //Computed
    var hasBeenPrepared: Bool {
        
        guard let setupType = type else {
            return false
        }
        
        switch setupType {
        case .Sleep:
            return minutesTimer != nil && (playlist != nil || mediaItem != nil)
        case .Wake:
            return wakeTime != nil && (playlist != nil || mediaItem != nil)
        }
        
        
    }
}