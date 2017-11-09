//
//  UtilitiesManager.swift
//  Sonno
//
//  Created by Lucas Maris on 11/25/15.
//  Copyright © 2015 Jenius Logic. All rights reserved.
//

import UIKit

class UtilitiesManager: NSObject {

    static let sharedInstance = UtilitiesManager()
    let formatter = NSDateFormatter()
    var todayStartDate: NSDate
    var calendar: NSCalendar
    
    override init() {

        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        formatter.AMSymbol = "am"
        formatter.PMSymbol = "pm"
        
        //Today date
        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(([.Day, .Month, .Year]), fromDate: NSDate())
        components.hour = 0
        components.minute = 0
        components.second = 0
        todayStartDate = calendar.dateFromComponents(components)!
        
        super.init()
    }
    
    func getTimeFromAngle(angle: Double) -> (String, NSDate) {
        
        let components = calendar.components(([.Day, .Month, .Year]), fromDate: NSDate())
        
        let decimalValue = (12 + 1.0/30.0 * (-angle % 360)) * 2
                
        components.hour = Int(decimalValue)
        components.minute = Int((decimalValue * 60) % 60)
        components.second = 0
        
        return (formatter.stringFromDate(calendar.dateFromComponents(components)!), calendar.dateFromComponents(components)!)
    }
    
    func getMinutesForAngle(angle: Double) -> String {
        
        let value = Int(angle/6 % 60.0)
        return "\(value)"
    }
    
    func getAngleFromMinutes(minutes: Int) -> Int {
        return 360 - minutes * Int(360.0/60.0)
    }
}
