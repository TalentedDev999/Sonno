//
//  SoundsTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/24/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

protocol SoundsTableViewControllerDelegate: class {
    func selectedSound(item: MediaItem)
}

private let cellIdentifier = "soundCell"

class SoundsTableViewController: GenericTableViewController {
    
    
    //MARK: Properties
    private var items = [MediaItem]()
    private var previousIndexPathSelected: NSIndexPath? //Manage play and stop icons
    weak var delegate: SoundsTableViewControllerDelegate!

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Close button
        if delegate != nil {
            let closeButton = UIBarButtonItem(image: UIImage(assetIdentifier: .CloseIcon), style: UIBarButtonItemStyle.Plain, target: self, action: "closePressed")
            self.navigationItem.leftBarButtonItem = closeButton
        }
        
        //TableUI
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: kScreenWidth, height: 20.0))
        self.tableView.alpha = 0.0
        self.tableView.rowHeight = 60.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateTable()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        PlayerManager.sharedInstance.avAudioStop()
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PlayListTableViewCell
        if cell == nil {
            cell = PlayListTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            if delegate == nil {
                cell?.addAudioIcon()
            }
        }
        
        cell?.numberLabel.text = "\(indexPath.row + 1)."
        cell?.cellLabel.text = items[indexPath.row].title ?? "Sound"
        
        return cell!
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let soundDelegate = self.delegate else {
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? PlayListTableViewCell {
                
                if let previousIndex = previousIndexPathSelected {
                    
                    //Check if the cell is playing
                    if previousIndex == indexPath {
                        cell.animateButtonChange()
                        PlayerManager.sharedInstance.avAudioStop()
                        return
                    }
                    
                    //Animate cell to restore play button
                    if let lastCell = tableView.cellForRowAtIndexPath(previousIndex) as? PlayListTableViewCell {
                        lastCell.animateButtonChange()
                    }
                }
                
                //Play sound
                var optionalSoundName: SoundName?
                
                if let fileName = items[indexPath.row].fileURL {
                    optionalSoundName = SoundName(rawValue: fileName)
                }
                
                
                guard let soundName = optionalSoundName else {
                    self.createAlertController("Error with file", message: "There was an error playing the sound, please pick another")
                    return
                }
                
                //TODO: Set default sound in case of error
                PlayerManager.sharedInstance.playAudioFromURL(soundName)
                
                //Change icon
                cell.animateButtonChange()
                
                //Set the last selected
                previousIndexPathSelected = indexPath
            }
            
            return
        }
        
        soundDelegate.selectedSound(items[indexPath.row])
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Sounds
    func getSounds() {
        
        //Get information from plist - easier to add/remove/modify objects
        if let path = NSBundle.mainBundle().pathForResource(PlistNamesConfig.SoundsPlist, ofType: "plist") {
            let dictionaryArray = NSArray(contentsOfFile: path)!
            
            for dictionary in dictionaryArray {
                
                let soundItem = MediaItem(dictionary: dictionary as! Dictionary<String, AnyObject>)
                
                //Add to our array
                items.append(soundItem)
            }
            
//            self.tableView.reloadData()
        }
    }
    
    //MARK: Extra
    func closePressed() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Animations
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells as! [PlayListTableViewCell]
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: PlayListTableViewCell = i
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        tableView.alpha = 1.0
        
        var index = 0
        
        for a in cells {
            let cell = a
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
            
        }
    }
}