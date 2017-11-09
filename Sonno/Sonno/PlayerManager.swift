//
//  PlayerManager.swift
//  Sonno
//
//  Created by Lucas Maris on 12/10/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class PlayerManager: NSObject {
    
    //Singleton
    static let sharedInstance = PlayerManager()
    
    //MARK: Properties
    
    //MPMusicPlayerController for Apple Music library items
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    //AVAudioPlayer for internal sounds
    var audioPlayer: AVAudioPlayer?
    
    //MARK: Init
    override init() {
        super.init()
        setupAVAudioPlayer()
    }
    
    //MARK: MediaController
    func playMedia(mediaItemCollection: MPMediaItemCollection) {
        
        self.enablePlaybackNotification()
        
        musicPlayer.beginGeneratingPlaybackNotifications()
        musicPlayer.stop()
        
        /* Start playing the items in the collection */
        musicPlayer.setQueueWithItemCollection(mediaItemCollection)
        musicPlayer.play()
    }
    
    func stopMedia() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        musicPlayer.stop()
        musicPlayer.endGeneratingPlaybackNotifications()
    }
    
    func enablePlaybackNotification() {
        /* Get notified when the state of the playback changes */
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "musicPlayerStateChanged:",
            name: MPMusicPlayerControllerPlaybackStateDidChangeNotification,
            object: nil)
        
        /* Get notified when the playback moves from one item
        to the other. In this recipe, we are only going to allow
        our user to pick one music file */
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "nowPlayingItemIsChanged:",
            name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
            object: nil)
        
        /* And also get notified when the volume of the
        music player is changed */
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "volumeIsChanged:",
            name: MPMusicPlayerControllerVolumeDidChangeNotification,
            object: nil)
    }
    
    func decreseVolumeWithTimer(minutes: Int) {
        
    }
    
    //MARK: AVAudioPlayer
    func setupAVAudioPlayer() {

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func playAudioFromURL(soundName: SoundName) {
        
        let itemURL: NSURL = NSBundle.mainBundle().URLForResource(soundName.rawValue, withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: itemURL, fileTypeHint: nil)
        }
        catch {
            return print("file not found. Error = \(error)")
        }
        
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    
    func avAudioStop() {
        
        guard let player = audioPlayer else {
            return
        }
        
        if player.playing { player.stop() }
    }
    
    func setAvAudioPlayerVolume(newVolume: Float) {
        audioPlayer?.volume = newVolume
    }
    
    func decreaseAvAudioPlayerVolumeBy(value: Float) {
        guard let player = audioPlayer else {
            return
        }
        
        
        player.volume = player.volume - value
        
        print("newVolume = \(player.volume)")
    }
    
    func getAvAudioPlayerVolume() -> Float {
        return audioPlayer?.volume ?? 0.5
    }
    
    //MARK: MPMediaController Notifications Methods
    func musicPlayerStateChanged(notification: NSNotification) {
        
        print("Player State Changed")
        
        /* Let's get the state of the player */
        let stateAsObject =
        notification.userInfo!["MPMusicPlayerControllerPlaybackStateKey"]
            as? NSNumber
        
        if let state = stateAsObject{
            
            /* Make your decision based on the state of the player */
            switch MPMusicPlaybackState(rawValue: state.integerValue)!{
            case .Stopped:
                /* Here the media player has stopped playing the queue. */
                print("Stopped")
            case .Playing:
                /* The media player is playing the queue. Perhaps you
                can reduce some processing that your application
                that is using to give more processing power
                to the media player */
                print("Paused")
            case .Paused:
                /* The media playback is paused here. You might want
                to indicate by showing graphics to the user */
                print("Paused")
            case .Interrupted:
                /* An interruption stopped the playback of the media queue */
                print("Interrupted")
            case .SeekingForward:
                /* The user is seeking forward in the queue */
                print("Seeking Forward")
            case .SeekingBackward:
                /* The user is seeking backward in the queue */
                print("Seeking Backward")
            }
            
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
        notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            /* Do something with Persistent ID */
            print("Persistent ID = \(id)")
        }
        
    }
    
    func volumeIsChanged(notification: NSNotification){
        print("Volume Is Changed")
        /* The userInfo dictionary of this notification is normally empty */
    }
}
