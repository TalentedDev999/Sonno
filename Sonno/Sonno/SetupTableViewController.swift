//
//  SetupTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

enum SetupOption: Int {
    case Sleep = 0,
    Wake
}

struct SetupType {
    var startTime: String!
    var option: SetupOption
}

protocol SetupTableViewControllerDelegate: class {
    func updateValues(option: SetupOption, startTime: String, playlist: Playlist?, sound: MediaItem?)
}

class SetupTableViewController: AudioTableViewController {
    
    var type: SetupType!
    private var footerView: SetupFooterView!
    weak var setupDelegate: SetupTableViewControllerDelegate!
    
    //MARK: Init & Dealloc
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(plistName: String, type: SetupType) {
        super.init(nibName: nil, bundle: nil)
        
        cellHeight = ScreenSizes.SmallScreen ? kScreenHeight * 0.12 : 77.5
        plistString = plistName
        
        self.type = type
    }

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createFooter(self.type)

        //Add Observer for shake to restart
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restart", name: NotificationsConfig.ShakeToRestart, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(assetIdentifier: .NavigationBackground), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.type.option == SetupOption.Wake {
            self.backgroundImageView.image = UIImage(assetIdentifier: .WakeWellBackground)
        }
    }
    
    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        
        case 0:
            presentSavedPlaylists()
        case 1:
            presentSoundsList()
        case 2:
            randomOptionSelected()
        default: break
        }
    }
    
    //MARK: Extra
    func presentSavedPlaylists() {
        let savedPlaylistViewController = SavedPlaylistsTableViewController()
        savedPlaylistViewController.selecting = true
        savedPlaylistViewController.delegate = self
        self.presentNavigationControllerWithRoot(savedPlaylistViewController)
    }
    
    func presentSoundsList() {
        let soundsTableViewController = SoundsTableViewController()
        soundsTableViewController.delegate = self
        soundsTableViewController.getSounds()
        self.presentNavigationControllerWithRoot(soundsTableViewController)
    }
    
    func presentNavigationControllerWithRoot(viewController: UIViewController) {
    
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.addNavigationBarTitle(title: "sonno")
        
        navigation.navigationBar.setBackgroundImage(UIImage(assetIdentifier: .NavigationBackground), forBarMetrics: UIBarMetrics.Default)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
        })
    }
    
    func randomOptionSelected() {
        resetAllCells()
        
        MediaManager.sharedInstance.getAllMedia()
        
        let randomNumber = arc4random_uniform(UInt32(MediaManager.sharedInstance.items.count))
        
        guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as? CenterTextTableViewCell else {
            return
        }
        
        let randomItem = MediaManager.sharedInstance.items[Int(randomNumber)]
        
        if (randomItem is Playlist) {
            cell.selectedWithTitle((randomItem as! Playlist).title)
            self.setupDelegate.updateValues(self.type.option, startTime: "05:23", playlist: (randomItem as! Playlist), sound: nil)
        } else {
            cell.selectedWithTitle((randomItem as! MediaItem).title ?? "Random Sound")
            self.setupDelegate.updateValues(self.type.option, startTime: "05:23", playlist: nil, sound: (randomItem as! MediaItem))
        }
        
    }
    
    func createFooter(type: SetupType) {
        
        footerView = SetupFooterView(type: type)
        footerView.delegate = self
        self.tableView.tableFooterView = footerView
        
        if self.type.option == SetupOption.Wake {
            self.backgroundImageView.image = UIImage(assetIdentifier: .WakeWellBackground)
            self.view.backgroundColor = kWakeWellBackgroundColor
        }
    }
    
    func resetAllCells() {
        self.tableView.reloadData()
    }
    
    //MARK: Shake to restart
    func restart() {
        self.createFooter(type)
        self.tableView.reloadData()
    }
}

//MARK: SavedPlaylistsTableViewControllerDelegate
extension SetupTableViewController: SavedPlaylistsTableViewControllerDelegate {
    func selectedPlaylist(playlist: Playlist) {
        
        self.tableView.reloadData { () -> () in
            
            guard let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? CenterTextTableViewCell else {
                return
            }
            
//            let mediaCollection = MPMediaItemCollection(items: playlist.items.map { $0.mpMediaItem } )
//            PlayerManager.sharedInstance.playMedia(mediaCollection)
            
            self.setupDelegate.updateValues(self.type.option, startTime: "05:23", playlist: playlist, sound: nil)
            
            cell.selectedWithTitle(playlist.title)
        }
    }
}

//MARK: SoundsTableViewControllerDelegate
extension SetupTableViewController: SoundsTableViewControllerDelegate {
    func selectedSound(item: MediaItem) {
        self.tableView.reloadData { () -> () in
            
            guard let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? CenterTextTableViewCell else {
                return
            }
            
            self.setupDelegate.updateValues(self.type.option, startTime: "05:23", playlist: nil, sound: item)
            
            cell.selectedWithTitle(item.title ?? "Sound")
        }
    }
}

//MARK: SetupFooterViewDelegate
extension SetupTableViewController: SetupFooterViewDelegate {
    
    func sendToAudio() {
        
        self.navigationController?.changeNavigationBarImageWithFade(0.33, imageIdentifier: .NavigationBackground)
        self.navigationController?.showViewController(AudioTableViewController(), sender: nil)
    }
    
    func sendToSettings() {
        self.navigationController?.changeNavigationBarImageWithFade(0.33, imageIdentifier: .NavigationBackground)
        self.navigationController?.showViewController(SettingsTableViewController(), sender: nil)
    }
}
