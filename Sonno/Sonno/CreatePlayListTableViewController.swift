//
//  CreatePlayListTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class CreatePlayListTableViewController: GenericTableViewController {
    
    var playlist = Playlist()
    var header: CreatePlaylistTableHeaderView!
    private let cellIdentifier = "playListCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPressed")
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editPressed")
        self.navigationItem.rightBarButtonItems = [editButton, addButton]
        
        //UI
//        self.view.backgroundColor = kSonnoColor
        self.tableView.separatorColor = UIColor.lightGrayColor()
        self.tableView.rowHeight = 50.0
//        createTableHeader()
        createTableFooter()
        
        //Know if its a new playlist or editing a previous one
        setupPlaylistTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PlayListTableViewCell
        if cell == nil {
            cell = PlayListTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.numberLabel.text = "\(indexPath.row + 1)."
        cell?.cellLabel.text = playlist.items[indexPath.row].displayTitle

        return cell!
    }
    
    //MARK:- TableView Delegate
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        print("Move cell in CreatePlaylistTableController from row \(fromIndexPath.row) to row \(toIndexPath.row)")
        let itemToMove = playlist.items[fromIndexPath.row]
        playlist.items.removeAtIndex(fromIndexPath.row)
        playlist.items.insert(itemToMove, atIndex: toIndexPath.row)
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print("delete cell in CreatePlaylistTableController at row \(indexPath.row)")
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            playlist.items.removeAtIndex(indexPath.row)
            tableView.endUpdates()
            
            //Update song numbers
            NSTimer.scheduledTimerWithTimeInterval(0.33, target: self, selector: "reloadTable", userInfo: nil, repeats: false)
        }
    }
    
    //MARK:- ScrollView Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        resignHeaderResponder()
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func addPressed() {
        
        self.resignHeaderResponder()
        
        self.navigationController?.setNavigationBarFontSize(24.0)
        
        let musicPlayListTableViewController = MusicPlayListTableViewController()
        musicPlayListTableViewController.delegate = self
        self.navigationController?.presentViewController(musicPlayListTableViewController, animated: true, completion: nil)
        
//        //Create alert sheet
//        let alertController = UIAlertController(title: "Select source", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Sounds", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
//        
//            print("present sounds picker")
//        }))
//        
//        alertController.addAction(UIAlertAction(title: "Music Library", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
//            print("present music library")
//
//
//        }))
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func editPressed() {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        resignHeaderResponder()
    }
    
    func createTableHeader() {
        header = CreatePlaylistTableHeaderView(frame: CGRectMake(0, 0, kScreenWidth, 60.0))
        header.delegate = self
        self.tableView.tableHeaderView = header
    }
    
    func createTableFooter() {
        
        let footerView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 60.0))
        
        let button = UIButton()
        button.setTitle("Save Playlist", forState: UIControlState.Normal)
        button.titleLabel?.customFont(.DisplayLight, size: 15.0)
        button.backgroundColor = kSonnoBlueColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: "createName", forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(footerView)
            make.height.equalTo(40.0)
        }
        
        self.tableView.tableFooterView = footerView
    }
    
    func resignHeaderResponder() {
//        if header.textField.isFirstResponder() {
//            header.textField.resignFirstResponder()
//        }
    }
    
    //MARK:- Playlist
    func createName() {
        
        if playlist.title == nil {
            //Create alert sheet
            let alertController = UIAlertController(title: "Your playlist needs a name", message: "enter playlist name", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.savePlaylist()
            }))
            alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Name..."
                textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            })
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.savePlaylist()
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        playlist.title = textField.text ?? ""
    }
    
    func checkValues() -> Bool {
        //Checks before saving
        
        if playlist.items.count == 0 {
            
            //Present error
            self.createAlertController("Missing items", message: "Make sure your playlist have some tunes")
            return false
        }
        
        if playlist.title == nil {
            
            //Present no title error
            self.createAlertController("No name", message: "Your playlist needs a name")
            return false
        }
        
        return true
    }
    
    func savePlaylist() {
        
        if checkValues() {
            
            setupPlaylistId()
            
            playlist.save()
            
            //Send notification about update
            NSNotificationCenter.defaultCenter().postNotificationName(SonnoUpdatedPlaylist, object: self, userInfo: nil)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func setupPlaylistId() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        guard let value = userDefault.valueForKey(kPlaylistCountKey) as? Int else {
            userDefault.setValue(1, forKey: kPlaylistCountKey)
            playlist.id = "1"
            return
        }
        
        if playlist.id == nil {
            userDefault.setValue(value + 1, forKey: kPlaylistCountKey)
            userDefault.synchronize()
            playlist.id = "\(value + 1)"
        }
    }
    
    func setupPlaylistTitle() {
        if playlist.title != nil {
//            header.textField.text = playlist.title
        }
    }
}

//MARK:- MPMediaPickerControllerDelegate

extension CreatePlayListTableViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        /* Print the items in the collection */
        for item in mediaItemCollection.items {
            
            guard let _ = item.artist, let _ = item.title else {
                continue
            }
            
            playlist.items.append(MediaItem(mpMediaItem: item))
            
            playlist.save()
        }        
        
        self.tableView.reloadData()
        
        /* Dismiss the media picker controller */
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }

    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        /* The media picker was cancelled */
        print("Media Picker was cancelled")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        
        self.navigationController?.setNavigationBarFontSize(kNavigationFontSize)
    }
}

//MARK:- CreatePlaylistTableHeaderViewDelegate

extension CreatePlayListTableViewController: CreatePlaylistTableHeaderViewDelegate {
    func setPlaylistName(name: String) {
        playlist.title = name
    }
}
