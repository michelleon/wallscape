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
    func setSleepHour(hour: Int) -> Bool {
        if (hour <= 12) && (hour > 0) {
            print("setSleepHour to \(hour)")
            self.sleepHour = hour
            return true
        } else {
            return false
        }
    }

    func setSleepMinutes(minutes: Int) -> Bool {
        if (minutes < 60) && (minutes > 0) {
            print("setSleepMinutes to \(minutes)")
            self.sleepMinute = minutes
            return true
        } else {
            return false
        }
    }
    
    func setWakeHour(hour: Int) -> Bool {
        if (hour <= 12) && (hour > 0) {
            print("setWakeHour to \(hour)")
            self.wakeHour = hour
            return true
        } else {
            return false
        }
    }
    
    func setWakeMinutes(minutes: Int) -> Bool {
        if (minutes < 60) && (minutes > 0) {
            print("setWakeMinutes to \(minutes)")
            self.wakeMinute = minutes
            return true
        } else {
            return false
        }
    }
    
    
    func getLocation(imgNum: Int) -> String? {
        if let location = self.locationByNum[imgNum] {
            return location
        }
        return nil
    }

    
}