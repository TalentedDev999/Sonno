//
//  TimerTableViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 12/20/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class TimerTableViewController: UITableViewController {
    
    var timers = [TimerSetup]()
    var audioVolumeTimer: NSTimer!
    let volumeView = MPVolumeView()
    let startButton = UIButton()
    var selectedIndex = 0 {
        didSet {
            createFooter(timers[selectedIndex])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeButton = UIBarButtonItem(image: UIImage(assetIdentifier: .CloseIcon), style: UIBarButtonItemStyle.Plain, target: self, action: "closePressed")
        self.navigationItem.leftBarButtonItem = closeButton
        
        //TableUI
        self.tableView.rowHeight = 100.0
        self.tableView.tableFooterView = UIView()
        self.tableView.bounces = false
        self.tableView.separatorStyle = .None
        
        if timers.count > 0 {
            createFooter(timers[selectedIndex])
        }
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("timerCell") as? TimersTableViewCell
        if cell == nil {
            cell = TimersTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "timerCell")
        }

        cell?.setWithTimer(timers[indexPath.row])

        return cell!
    }
    
    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        stopMedia()
        
        startButton.enabled = true
        
        selectedIndex = indexPath.row
    }

    func createFooter(timer: TimerSetup) {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 64.0 - CGFloat(100 * timers.count)))
        
        var displayString: String!
        
        if let minutes = timer.minutesTimer {
            displayString = "\(minutes) min"
        } else {
            displayString = UtilitiesManager.sharedInstance.formatter.stringFromDate(timer.wakeTime!)
        }
        
        
        let footerView = SetupFooterView(type: SetupType(startTime: displayString , option: timer.type ?? .Sleep))
        footerView.hideButtons()
        footerView.circularSlider.angle = timer.angle!
        PlayerManager.sharedInstance.setAvAudioPlayerVolume(timer.volume)
        footerView.userInteractionEnabled = false
        footerView.volumeSlider.setValue(timer.volume, animated: false)
        footerView.backgroundColor = UIColor(patternImage: UIImage(assetIdentifier: timer.type! == .Sleep ? .Background : .WakeWellBackground))
        containerView.addSubview(footerView)
        footerView.circularSlider.setNeedsDisplay()
        
        startButton.setTitle("START", forState: UIControlState.Normal)
        startButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        startButton.titleLabel?.customFont(.DisplayRegular, size: 30.0)
        startButton.backgroundColor = UIColor.whiteColor()
        startButton.addTarget(self, action: "start", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(startButton)
        startButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(footerView.snp_bottom)
            make.left.right.bottom.equalTo(containerView)
        }
        
        self.tableView.tableFooterView = containerView
    }
    
    //MARK: Extra
    func closePressed() {
        
        stopMedia()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func stopMedia() {
        if audioVolumeTimer != nil {
            audioVolumeTimer.invalidate()
        }
        
        PlayerManager.sharedInstance.stopMedia()
        PlayerManager.sharedInstance.avAudioStop()
    }

    func start() {
        
        startButton.enabled = false
        
        if let playlist = timers[selectedIndex].playlist {
            
            let items = playlist.items.map({ $0.mpMediaItem! })
            
            //Enable audio session
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            
            //Set items to play
            PlayerManager.sharedInstance.playMedia(MPMediaItemCollection(items: items))
            
            //Set timer for volume decrease over time
            audioVolumeTimer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "updateMpMediaAudio", userInfo: nil, repeats: true)
            
            //Volume slider - invisible
            volumeView.frame = CGRectMake(50, 400, 200, 40)
            self.view.addSubview(volumeView)
            volumeView.alpha = 0.0
        }
        
        if let sound = timers[selectedIndex].mediaItem {
            
            //Set volume
            PlayerManager.sharedInstance.setAvAudioPlayerVolume(timers[selectedIndex].volume)
            
            //Start playing sound
            PlayerManager.sharedInstance.playAudioFromURL(SoundName(rawValue: sound.fileURL != "" ? (sound.fileURL ?? "birds") : "birds")!)
            
            //Set timer for volume decrease over time
            audioVolumeTimer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "updateAvMediaAudio", userInfo: nil, repeats: true)
        }
    }
    
    func updateAvMediaAudio() {
        
        let decreasePercentaje = timers[selectedIndex].volume / (Float(timers[selectedIndex].minutesTimer ?? 15))
        
        print(decreasePercentaje)
        
        //Decrease volume
        PlayerManager.sharedInstance.decreaseAvAudioPlayerVolumeBy(timers[selectedIndex].volume / (Float(timers[selectedIndex].minutesTimer ?? 15) * 5.0))
        let currentValue = PlayerManager.sharedInstance.getAvAudioPlayerVolume()
        
        //Stop if volume < 0
        if currentValue <= 0.0 {
            audioVolumeTimer.invalidate()
        }
    }
    
    func updateMpMediaAudio() {
        
        for subview in self.volumeView.subviews {
            if (subview as UIView).description.rangeOfString("MPVolumeSlider") != nil {
                
                // Set volume
                let volumeSlider = subview as! UISlider
                
                let currentValue = volumeSlider.value - timers[selectedIndex].volume / (Float(timers[selectedIndex].minutesTimer ?? 5) * 5.0)
                volumeSlider.setValue(currentValue, animated: false)
                
                if currentValue < 0.0 {
                    audioVolumeTimer.invalidate()
                }
                break
            }
        }
    }
}
