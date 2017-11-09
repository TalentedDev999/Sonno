//
//  ConfirmationViewController.swift
//  Sonno
//
//  Created by Lucas Maris on 12/8/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class ConfirmationViewController: GenericViewController {

    
    //MARK: Properties
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: "startPressed", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    @IBOutlet weak var sleepSoundLabel: UILabel!
    @IBOutlet weak var sleepMediTitleLabel: UILabel!
    @IBOutlet weak var sleepTimerLabel: UILabel!
    
    @IBOutlet weak var wakeMediaLabel: UILabel!
    @IBOutlet weak var wakeMediaTitleLabel: UILabel!
    @IBOutlet weak var wakeTimerLabel: UILabel!
    
    private var sleepTimer: TimerSetup!
    private var wakeTimer: TimerSetup!
    
    
    //MARK: Init & Dealloc
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //timers
        setupTimers()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatedTimer:", name: NotificationsConfig.UpdatedCircularSliderValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatedVolume:", name: NotificationsConfig.VolumeSliderChanged, object: nil)
        //Add Observer for shake to restart
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restart", name: NotificationsConfig.ShakeToRestart, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTimers() {
        
        sleepTimer = TimerSetup()
        wakeTimer = TimerSetup()
        
        sleepTimer.type = SetupOption.Sleep
        wakeTimer.type = SetupOption.Wake
        
        //Today date
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(([.Day, .Month, .Year, .Hour, .Minute]), fromDate: NSDate())
        print("Date = \(components.day), Hour = \(components.hour), Minutes = \(components.minute)")
        
        components.hour = 7
        components.minute = 30
        
        var date = calendar.dateFromComponents(components)
        
        if components.hour > 8 {
            date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])
        }
        
        wakeTimer.wakeTime = date
        wakeTimer.angle = 256
    }
    
    func getTimers() -> [TimerSetup] {
        var array = [TimerSetup]()
        
        if sleepTimer.hasBeenPrepared {
            array.append(sleepTimer)
        }
        
        if wakeTimer.hasBeenPrepared {
            array.append(wakeTimer)
        }
        
        return array
    }
    
    func startPressed() {
        
        let timersArray = getTimers()
        
        if timersArray.count > 0 {
            
            //Start what ever we want
            let timerViewController = TimerTableViewController()
            timerViewController.timers = timersArray
            let navigation = UINavigationController(rootViewController: timerViewController)
            navigation.addNavigationBarTitle(title: "sonno")
            
            navigation.navigationBar.setBackgroundImage(UIImage(assetIdentifier: .NavigationBackground), forBarMetrics: UIBarMetrics.Default)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
            })
        } else {
            self.createAlertController("Missing Setup", message: "Make sure you set up at least one of the options fully")
        }
    }
    
    func updatedTimer(notification: NSNotification) {
        
        guard let dictionary = notification.userInfo else {
            return
        }
        
        if let number = dictionary["type"] as? Int {
            let type = SetupOption(rawValue: number)
            
            switch type! {
            case .Sleep:
                if let value = dictionary["minutes"] as? Int {
                    sleepTimerLabel.text = "is set for \(value) minutes"
                    sleepTimer.minutesTimer = value
                }
                
                if let angle = dictionary["angle"] as? Int {
                    sleepTimer.angle = angle
                }
            case .Wake:
                if let value = dictionary["wakeTime"] as? NSDate {
                    wakeTimerLabel.text = "begins at \(UtilitiesManager.sharedInstance.formatter.stringFromDate(value))"
                    
                    
                    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                    let components = calendar.components(([.Day, .Month, .Year, .Hour, .Minute]), fromDate: value)
                    
                    var date = calendar.dateFromComponents(components)
                    
                    let currentDate = NSDate()
                    
                    if date?.earlierDate(currentDate) == date {
                        date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: value, options: [])
                    }
                                        
                    wakeTimer.wakeTime = date ?? value //Safe check for optional - never happens
                }
                
                if let angle = dictionary["angle"] as? Int {
                    wakeTimer.angle = angle
                }
            }
        }
    }
    
    func updatedVolume(notification: NSNotification) {
        guard let dictionary = notification.userInfo else {
            return
        }
        
        if let number = dictionary["type"] as? Int {
            let type = SetupOption(rawValue: number)
            
            switch type! {
            case .Sleep:

                if let newValue = dictionary["newValue"] as? Float {
                    sleepTimer.volume = newValue
                }
            case .Wake:
                if let newValue = dictionary["newValue"] as? Float {
                    wakeTimer.volume = newValue
                }
            }
        }
    }
    
    //MARK: Shake to restart
    func restart() {
        setupTimers()
        resetLabelValues()
    }
    
    func resetLabelValues() {
        //Sleep
        sleepSoundLabel.text = ""
        sleepMediTitleLabel.text = ""
        sleepTimerLabel.text = ""
        
        //Wake
        wakeMediaLabel.text = ""
        wakeMediaTitleLabel.text = ""
        wakeTimerLabel.text = ""
    }
}

//MARK: SetupTableViewControllerDelegate
extension ConfirmationViewController: SetupTableViewControllerDelegate {
    func updateValues(option: SetupOption, startTime: String, playlist: Playlist?, sound: MediaItem?) {
        switch option {
        case .Sleep:
            sleepSoundLabel.text = playlist == nil ? "Sound" : "Playlist"
            sleepMediTitleLabel.text = playlist?.title ?? sound?.title
            sleepTimer.playlist = playlist
            sleepTimer.mediaItem = sound
            
        case .Wake:
            wakeMediaLabel.text = playlist == nil ? "Sound" : "Playlist"
            wakeMediaTitleLabel.text = playlist?.title ?? sound?.title
            wakeTimer.playlist = playlist
            wakeTimer.mediaItem = sound
        }
    }
}

