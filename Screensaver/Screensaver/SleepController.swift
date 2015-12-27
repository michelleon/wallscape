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
    var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("getTime"),
            userInfo: nil,
            repeats: true)
        tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleMenuPress:"))
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
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
    
    func handleMenuPress(sender: UITapGestureRecognizer) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Do you want to wake up early?", message: "This will reset your alarm", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        let confirmAction: UIAlertAction = UIAlertAction(title: "Confirm", style: .Default) {
            action -> Void in
            self.wakeUp()
        }
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(confirmAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! ViewController
        vc.brain = self.brain!
    }
    
    
}