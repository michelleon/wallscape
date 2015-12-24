//
//  SleepController.swift
//  Screensaver
//
//  Created by Michelle Leon on 12/23/15.
//  Copyright © 2015 Michelle Leon. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class SleepController: UIViewController {
    
    var timer = NSTimer()
    var brain: ScreensaverBrain? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("getTime"),
            userInfo: nil,
            repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        <#code#>
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        <#code#>
//    }

    func getTime() {
        brain!.updateTime()
        if brain!.isSleepTime == false {
            wakeUp()
        }
    }
    
    func wakeUp() {
        performSegueWithIdentifier("wakeUpSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! ViewController
        vc.brain = self.brain!
    }
    
    
}