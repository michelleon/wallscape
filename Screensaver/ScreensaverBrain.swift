//
//  ScreensaverBrain.swift
//  Screensaver
//
//  Created by Michelle Leon on 11/26/15.
//  Copyright © 2015 Michelle Leon. All rights reserved.
//

import Foundation

let weatherKey = "30b27f2565d58ab08511efd9652d8500"

class ScreensaverBrain {
    
    var wakeHour: Int? = nil
    var wakeMinute: Int? = nil
    var sleepMinute: Int? = nil
    var sleepHour: Int? = nil
    var userSetAlarm = false
    var isSleepTime = false
    var sleepToggle = "PM"
    var wakeToggle = "AM"

    var hour = 0
    var minutes = 0
    var month = ""
    var day = 0
    var year = 0
    var timer = NSTimer()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let locationByNum: [Int:String] = [
        0 : "San Diego, California",
        1 : "Iceland",
        3 : "Ocean Beach, California",
        2 : "Goðafoss, Iceland",
        4 : "Aldeyjarfoss, Iceland",
        5 : "Gullfoss, Iceland",
        6 : "Lake Tekapo, New Zealand",
        7 : "Seal Beach, California",
        8 : "Valley of Fire, Nevada",
        9 : "Torres del Paine, Chile",
        10 : "Mount Cook, New Zealand",
        11 : "La Jolla, California",
        12 : "Milford Sound, New Zealand",
        13 : "Machu Picchu, Peru",
        14 : "Kirkjufell, Iceland",
        15 : "San Diego, California"

    ]

    private var monthByNum: [Int:String] = [
        1 : "January",
        2 : "February",
        3 : "March",
        4 : "April",
        5 : "May",
        6 : "June",
        7 : "July",
        8 : "August",
        9 : "September",
        10 : "October",
        11 : "November",
        12 : "December"
    ]
    
//    init() {
//        timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
//            target: self,
//            selector: Selector("updateTime"),
//            userInfo: nil,
//            repeats: true)
//    }
    
    // REMEMBER TO CONvert hours to +12 depending on AM or PM
    func setAMPM(sleep: String, wake: String) {
        self.sleepToggle = sleep
        self.wakeToggle = wake
    }

//    func setTimes(time: Int, field: String) -> Bool {
//        switch field {
//        case "sleepHour" :
//            return self.setSleepHour(time)
//        case "sleepMinute" :
//            return self.setSleepMinutes(time)
//        case "wakeHour" :
//            return self.setWakeHour(time)
//        case "wakeMinute" :
//            return self.setWakeMinutes(time)
//        default:
//            return false
//        }
//    }
    
    func updateTime() {
        let curr_date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: curr_date)
        hour = components.hour
        minutes = components.minute
        month = monthByNum[components.month]!
        day = components.day
        year = components.year
        
        if isSleepTime == true {
            if (wakeHour != nil) && (wakeMinute != nil) {
//                print("brain wake time \(wakeHour!):\(wakeMinute)")
                if wakeHour! == hour && (wakeMinute! == minutes) {
                    print("time to wake up")
                    wakeUp()
//                    wakeUp() //perform segue
                }
            }
        } else if let sleepHour = sleepHour {
            if let sleepMinute = sleepMinute {
                if (sleepHour == hour) && (sleepMinute == minutes) && (userSetAlarm == true) {
                    print("goToSleep called first time")
                    goToSleep()
                }
            }
        }
    }

    func wakeUp() {
        isSleepTime = false
    }
    
    func goToSleep() {
        isSleepTime = true
    }
    
    func getUserDefaults() -> Bool {
        // return user defaults otherwise nil
        if defaults.integerForKey("remember") == 1 {
            self.sleepHour = defaults.integerForKey("sleepHour")
            self.wakeHour = defaults.integerForKey("wakeHour")
            self.sleepMinute = defaults.integerForKey("sleepMinute")
            self.wakeMinute = defaults.integerForKey("wakeMinute")
            self.sleepToggle = defaults.stringForKey("sleepPM")!
            self.wakeToggle = defaults.stringForKey("wakeAM")!
            return true
        }
        return false
    }
    
    func setUserDefaults() {
        defaults.setInteger(self.sleepHour!, forKey: "sleepHour")
        defaults.setInteger(self.sleepMinute!, forKey: "sleepMinute")
        defaults.setInteger(self.wakeHour!, forKey: "wakeHour")
        defaults.setInteger(self.wakeMinute!, forKey: "wakeMinute")
        defaults.setObject(self.sleepToggle, forKey: "sleepPM")
        defaults.setObject(self.wakeToggle, forKey: "wakeAM")
        defaults.setInteger(1, forKey: "remember")
    }
    
    func clearUserDefaults() {
        defaults.setInteger(0, forKey: "sleepHour")
        defaults.setInteger(0, forKey: "sleepMinute")
        defaults.setInteger(0, forKey: "wakeHour")
        defaults.setInteger(0, forKey: "wakeMinute")
        defaults.setInteger(0, forKey: "remember")
    }
    
    func getLocation(imgNum: Int) -> String? {
        if let location = self.locationByNum[imgNum] {
            return location
        }
        return nil
    }
    
    
    func setAlarm(sleepHour: Int, sleepMinute: Int, wakeHour: Int, wakeMinute: Int) {
        // set times from input
        setSleepHour(sleepHour)
        setSleepMinutes(sleepMinute)
        setWakeHour(wakeHour)
        setWakeMinutes(wakeMinute)
        
        // change to military time
        if self.sleepToggle == "AM" {
            if self.sleepHour == 12 {
                self.sleepHour = 0
            }
        } else {
            if self.sleepHour < 12 {
                self.sleepHour = self.sleepHour! + 12
            }
        }
        if self.wakeToggle == "AM" {
            if self.wakeHour == 12 {
                self.wakeHour = 0
            }
        } else {
            if self.wakeHour < 12 {
                self.wakeHour = self.wakeHour! + 12
            }
        }
        self.userSetAlarm = true
    }

    func getGreetingByTimeOfDay(hour: Int) -> String {
        // hour is in 24 hr mode
        if hour < 12 {
            return "Good morning!"
//        } else if hour < 14 {
//            return "Hungover much?"
        } else if hour < 17 {
            return "Good afternoon sleepyhead!"
//        } else if hour < 19 {
//            return "Good evening!"
        } else {
            return "Waking up a bit late, aren't ya?"
        }
    }
    
    func resetAlarm() {
        self.sleepHour = nil
        self.sleepMinute = nil
        self.wakeHour = nil
        self.wakeMinute = nil

    }
    
    func toggleAMPM(text: String) -> String {
        if text == "AM" {
            return "PM"
        } else {
            return "AM"
        }
    }
    
    func formatHour(militaryHour: Int) -> String {
        var hour = militaryHour
        if militaryHour > 12 {
            hour = militaryHour - 12
        }
        if militaryHour == 0 {
            hour = 12
        }
        return "\(hour)"
    }
    
    func formatMinutes(minutes: Int) -> String {
        var retval: String
        if minutes < 10 {
            retval = "0\(minutes)"
        } else {
            retval = "\(minutes)"
        }
        return retval
    }

    private func setSleepHour(hour: Int) -> Bool {
        if (hour <= 12) && (hour > 0) {
            print("setSleepHour to \(hour)")
            self.sleepHour = hour
            return true
        } else {
            return false
        }
    }
    
    private func setSleepMinutes(minutes: Int) -> Bool {
        if (minutes < 60) && (minutes >= 0) {
            print("setSleepMinutes to \(minutes)")
            self.sleepMinute = minutes
            return true
        } else {
            return false
        }
    }
    
    private func setWakeHour(hour: Int) -> Bool {
        if (hour <= 12) && (hour > 0) {
            print("setWakeHour to \(hour)")
            self.wakeHour = hour
            return true
        } else {
            return false
        }
    }

    private func setWakeMinutes(minutes: Int) -> Bool {
        if (minutes < 60) && (minutes >= 0) {
            print("setWakeMinutes to \(minutes)")
            self.wakeMinute = minutes
            return true
        } else {
            return false
        }
    }
    
}