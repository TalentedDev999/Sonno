//
//  SavedPlaylistsTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

protocol SavedPlaylistsTableViewControllerDelegate: NSObjectProtocol {
    func selectedPlaylist(playlist: Playlist)
}

class SavedPlaylistsTableViewController: GenericTableViewController {
    
    private let cellIdentifier = "playlistCell"
    var selecting = false
    
    //Delegate
    weak var delegate: SavedPlaylistsTableViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        PlaylistManager.sharedInstance.getSavedPlaylists()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = 50.0
//        self.view.backgroundColor = kSonnoColor
        
        if selecting {
            let closeButton = UIBarButtonItem(image: UIImage(assetIdentifier: .CloseIcon), style: UIBarButtonItemStyle.Plain, target: self, action: "closePressed")
            self.navigationItem.leftBarButtonItem = closeButton
        }
        
        self.tableView.tableHeaderView = SavedPlaylistTableHeaderView(frame: CGRectMake(0, 0, kScreenWidth, 40.0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaylistManager.sharedInstance.playlists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PlayListTableViewCell
        if cell == nil {
            cell = PlayListTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.clearColor()
        }
        
        cell?.numberLabel.text = "\(indexPath.row + 1)."
        cell?.cellLabel.text = PlaylistManager.sharedInstance.playlists[indexPath.row].title
        cell?.songsCount.text = "\(PlaylistManager.sharedInstance.playlists[indexPath.row].items.count)"
        
        return cell!
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if !selecting {
            //Add observer for playlist changes
            let defaultNotificationCenter = NSNotificationCenter.defaultCenter()
            defaultNotificationCenter.addObserver(self, selector: Selector("updatePlaylists"), name: SonnoUpdatedPlaylist, object: nil)
            
            //Show playlist details
            let playlistTableViewController = CreatePlayListTableViewController()
            playlistTableViewController.playlist = PlaylistManager.sharedInstance.playlists[indexPath.row]
            
            self.navigationController?.showViewController(playlistTableViewController, sender: nil)
        } else {
            
            dispatch_async(dispatch_get_main_queue(),{
                UIView.animateWithDuration(0.33,
                    animations: {
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    },
                    completion: nil)
            });
            
            //Select the cell for the alarm
            guard let del = delegate else {
                return
            }
            
            del.selectedPlaylist(PlaylistManager.sharedInstance.playlists[indexPath.row])
        }
    }
    
    //MARK: Playlists
    func updatePlaylists() {
        PlaylistManager.sharedInstance.getSavedPlaylists()
        self.tableView.reloadData()
    }
    
    //MARK: Extra
    func closePressed() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}


