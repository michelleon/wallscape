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
    
    let locationByNum: [Int:String] = [
        2 : "Huacachina, Peru",
        4 : "Mongolia",
        7 : "Dolomites, Italy",
        9 : "Paul Smiths, United States",
        10 : "Dolomites, Italy",
        12 : "Colorado, United States",
        13 : "Manali, India",
        14 : "Los Flamencos National Reserve, Chile",
        15 : "Zermatt",
        16 : "Corsica, France",
        17 : "Tromsø, Norway",
        18 : "Bellingham, United States",
        19 : "Banff, Canada",
        20 : "Mallorca, Spain",
        25 : "Chaldon Herring, United Kingdom",
        26 : "Corno Nero, Italy",
        27 : "Bryce Canyon, United States",
        30 : "Lake Louise, Canada",
        31 : "Ebensee, Austria",
        32 : "Cascais, Portugal",
        33 : "Cascais, Portugal",
        34 : "Guincho, Portugal",
        35 : "Bournemouth, Vereinigtes Königreich",
        36 : "Daytona Beach, United States",
        37 : "Praia do Guincho, Portugal",
        38 : "Salt Creek Falls, United States",
        39 : "Seekofelhütte, Fosses, Italien"
    ]

    func getLocation(imgNum: Int) -> String? {
        if let location = self.locationByNum[imgNum] {
            return location
        }
        return nil
    }

    
}