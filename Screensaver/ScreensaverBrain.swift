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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let locationByNum: [Int:String] = [
        0 : "Broken Hill, New South Wales",
        1 : "Iceland",
        2 : "Goðafoss, Iceland",
        4 : "Aldeyjarfoss, Iceland",
        5 : "Gullfoss, Iceland"
//        2 : "Huacachina, Peru",
//        4 : "Mongolia",
//        7 : "Dolomites, Italy",
//        9 : "Paul Smiths, United States",
//        10 : "Dolomites, Italy",
//        12 : "Colorado, United States",
//        13 : "Manali, India",
//        14 : "Los Flamencos National Reserve, Chile",
//        15 : "Zermatt",
//        16 : "Corsica, France",
//        17 : "Zion National Park, United States",
//        18 : "Tromsø, Norway",
//        19 : "Bellingham, United States",
//        20 : "Banff, Canada",
//        21 : "Mallorca, Spain",
//        25 : "Chaldon Herring, United Kingdom",
//        26 : "Corno Nero, Italy",
//        27 : "Bryce Canyon, United States",
//        30 : "Lake Louise, Canada",
//        31 : "Ebensee, Austria",
//        32 : "Cascais, Portugal",
//        33 : "Cascais, Portugal",
//        34 : "Guincho, Portugal",
//        35 : "Bournemouth, Vereinigtes Königreich",
//        36 : "Daytona Beach, United States",
//        37 : "Praia do Guincho, Portugal",
//        38 : "Salt Creek Falls, United States",
//        39 : "Seekofelhütte, Fosses, Italien"
    ]
    // REMEMBER TO CONvert hours to +12 depending on AM or PM 
    func setAMPM(sleep: String, wake: String) {
        self.sleepToggle = sleep
        self.wakeToggle = wake
    }

    func setTimes(time: Int, field: String) -> Bool {
        switch field {
        case "sleepHour" :
            return self.setSleepHour(time)
        case "sleepMinute" :
            return self.setSleepMinutes(time)
        case "wakeHour" :
            return self.setWakeHour(time)
        case "wakeMinute" :
            return self.setWakeMinutes(time)
        default:
            return false
        }
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
    
    
    func setAlarm() {
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
    
    func resetAlarm() {
        self.sleepHour = nil
        self.sleepMinute = nil
        self.wakeHour = nil
        self.wakeMinute = nil
        self.isSleepTime = false

    }
    
    func toggleAMPM(text: String) -> String {
        if text == "AM" {
            return "PM"
        } else {
            return "AM"
        }
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