//
//  AudioTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 11/23/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class AudioTableViewController: GenericTableViewController {
    
    private let cellIdentifier = "audioCell"
    var items = [CellOptionItem]()
    var cellHeight: CGFloat = (kScreenHeight - 44.0)/4
    var plistString = "AudioItems"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data
        getAudioOptions()
        
        //View UI
//        self.view.backgroundColor = kSonnoColor
        
        //TableUI
        tableView.rowHeight = cellHeight
        tableView.bounces = false
        tableView.separatorStyle = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? CenterTextTableViewCell
        if cell == nil {
            cell = CenterTextTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.resetCell()
        
        cell?.backgroundColor = UIColor(hex: items[indexPath.row].hexColor)
        cell?.cellLabel.text = items[indexPath.row].title

        return cell!
    }
    
    //MARK:- TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        switch indexPath.row {
        case 1:
            let soundsViewController = SoundsTableViewController()
            soundsViewController.getSounds()
            self.navigationController?.showViewController(soundsViewController, sender: nil)
        case 2:
            self.navigationController?.showViewController(CreatePlayListTableViewController(), sender: nil)
        case 3:
            self.navigationController?.showViewController(SavedPlaylistsTableViewController(nibName: nil, bundle: nil), sender: nil)
        default: break
        }
    }
    
    func getAudioOptions() {
        
        //Get information from plis - easier to add/remove/modify objects
        if let path = NSBundle.mainBundle().pathForResource(plistString, ofType: "plist") {
            let dictionaryArray = NSArray(contentsOfFile: path)!
            
            for dictionary in dictionaryArray {
                
                let audioItem = CellOptionItem(dictionary: dictionary as! NSDictionary)
                
                //Add to our array
                items.append(audioItem)
            }
            
            self.tableView.reloadData()
        }
    }
}
