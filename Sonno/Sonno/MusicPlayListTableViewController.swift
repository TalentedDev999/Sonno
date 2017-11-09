//
//  MusicPlayListTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class MusicPlayListTableViewController: MPMediaPickerController { //, AVAudioPlayerDelegate {

    var myMusicPlayer: MPMusicPlayerController?
    var buttonPickAndPlay: UIButton?
    var buttonStopPlaying: UIButton?
    var mediaPicker: MPMediaPickerController?
    
    var items = ["sounds", "rain", "birdsong", "crickects"]
    let cellIdentifier = "soundCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        delegate = self
        allowsPickingMultipleItems = true
        showsCloudItems = true
        
//        buttonPickAndPlay = UIButton(type: .System)
//        
//        if let pickAndPlay = buttonPickAndPlay {
//            pickAndPlay.frame = CGRect(x: 0, y: 0, width: 200, height: 37)
//            pickAndPlay.center = CGPoint(x: view.center.x, y: view.center.y - 50)
//            pickAndPlay.setTitle("Pick and Play", forState: .Normal)
//            pickAndPlay.addTarget(self,
//                action: "displayMediaPickerAndPlayItem",
//                forControlEvents: .TouchUpInside)
//            view.addSubview(pickAndPlay)
//        }
//        
//        buttonStopPlaying = UIButton(type: .System)
//        
//        if let stopPlaying = buttonStopPlaying {
//            stopPlaying.frame = CGRect(x: 0, y: 0, width: 200, height: 37)
//            stopPlaying.center = CGPoint(x: view.center.x, y: view.center.y + 50)
//            stopPlaying.setTitle("Stop Playing", forState: .Normal)
//            stopPlaying.addTarget(self,
//                action: "stopPlayingAudio",
//                forControlEvents: .TouchUpInside)
//            view.addSubview(stopPlaying)
//        }
    }
    
    //MARK: Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Media Player
    func musicPlayerStateChanged(notification: NSNotification){
        
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
    
    func stopPlayingAudio(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let player = myMusicPlayer{
            player.stop()
        }
        
    }
    
    func displayMediaPickerAndPlayItem(){
        
        self.navigationController?.setNavigationBarFontSize(24.0)
        
        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        
        if let picker = mediaPicker{
            
            print("Successfully instantiated a media picker")
//            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            picker.showsCloudItems = true
//            view.addSubview(picker.view)
            
            dispatch_async(dispatch_get_main_queue(),{
               self.navigationController?.presentViewController(picker, animated: true, completion: nil)
            });
            
        } else {
            print("Could not instantiate a media picker")
        }
        
    }
}

//extension MusicPlayListTableViewController: MPMediaPickerControllerDelegate {
//    
//    func mediaPicker(mediaPicker: MPMediaPickerController,
//        didPickMediaItems mediaItemCollection: MPMediaItemCollection){
//            
//            print("Media Picker returned")
//            
//            /* Instantiate the music player */
//            
//            myMusicPlayer = MPMusicPlayerController()
//            
//            if let player = myMusicPlayer{
//                player.beginGeneratingPlaybackNotifications()
//                
//                /* Get notified when the state of the playback changes */
//                NSNotificationCenter.defaultCenter().addObserver(self,
//                    selector: "musicPlayerStateChanged:",
//                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification,
//                    object: nil)
//                
//                /* Get notified when the playback moves from one item
//                to the other. In this recipe, we are only going to allow
//                our user to pick one music file */
//                NSNotificationCenter.defaultCenter().addObserver(self,
//                    selector: "nowPlayingItemIsChanged:",
//                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
//                    object: nil)
//                
//                /* And also get notified when the volume of the
//                music player is changed */
//                NSNotificationCenter.defaultCenter().addObserver(self,
//                    selector: "volumeIsChanged:",
//                    name: MPMusicPlayerControllerVolumeDidChangeNotification,
//                    object: nil)
//                
//                /* Start playing the items in the collection */
//                player.setQueueWithItemCollection(mediaItemCollection)
//                player.play()
//                
//                /* Finally dismiss the media picker controller */
//                mediaPicker.dismissViewControllerAnimated(true, completion: nil)
//                
//            }
//    }
//    
//    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
//        /* The media picker was cancelled */
//        print("Media Picker was cancelled")
//        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
//        
//        self.navigationController?.setNavigationBarFontSize(kNavigationFontSize)
//    }
//}