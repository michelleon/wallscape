//
//  chooseWakeTime.swift
//  Screensaver
//
//  Created by Michelle Leon on 12/8/15.
//  Copyright © 2015 Michelle Leon. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class chooseWakeTime: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var wakeMinutesField: UITextField!
    @IBOutlet weak var wakeHourField: UITextField!
    @IBOutlet weak var sleepMinutesField: UITextField!
    @IBOutlet weak var sleepHourField: UITextField!
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var sleepToggle: UIButton!

    @IBOutlet weak var wakeToggle: UIButton!
    
    var userCheckedRememberSettings = false
    var brain: ScreensaverBrain? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBox.setBackgroundImage(UIImage(named: "unchecked_box_2.png"), forState: .Normal)
        checkBox.setImage(UIImage(named: "checked_box_2.png"), forState: .Selected)
        checkBox.backgroundColor = UIColor.clearColor()
        sleepToggle.setTitle("PM", forState: .Normal)
        wakeToggle.setTitle("AM", forState: .Normal)
        errorMessage.text = ""
        self.sleepHourField.delegate = self // assigning delegate
        if brain!.getUserDefaults() == true {
            sleepHourField.text = "\(brain!.sleepHour!)"
            sleepMinutesField.text = brain!.formatMinutes(brain!.sleepMinute!)
            wakeHourField.text = "\(brain!.wakeHour!)"
            wakeMinutesField.text = brain!.formatMinutes(brain!.wakeMinute!)
            sleepToggle.setTitle(brain!.sleepToggle, forState: .Normal)
            wakeToggle.setTitle(brain!.wakeToggle, forState: .Normal)
            
        }
    }
    
    override var preferredFocusedView: UIView? {
        get {
            return self.sleepHourField
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toggleSleep(sender: AnyObject) {
        sender.setTitle(brain!.toggleAMPM(sender.currentTitle!!), forState: .Normal)
    }
    
    @IBAction func toggleWake(sender: AnyObject) {
        sender.setTitle(brain!.toggleAMPM(sender.currentTitle!!), forState: .Normal)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("called textfieldshouldreturn")
        //        self.view.endEditing(true)
        return true
    }
    

    @IBAction func toggleRemember(sender: AnyObject) {
        if let button = sender as? UIButton {
            print("selected checkbox")
            if userCheckedRememberSettings == false {
                button.setBackgroundImage(UIImage(named: "checked_box_2.png"), forState: .Normal)
                userCheckedRememberSettings = true
            } else {
                userCheckedRememberSettings = false
                button.setBackgroundImage(UIImage(named: "unchecked_box_2.png"), forState: .Normal)
            }
        }
    }
    
    

    @IBAction func setSleepHour(sender: AnyObject) {
        if let inp = sender as? UITextField {
            let hour = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            if hour > 12 || hour < 1 {
                errorMessage.text = "Sleep hour input is not between 1 and 12"
            } else {
                brain!.setTimes(hour!, field: "sleepHour")
                errorMessage.text = ""
            }
        }
    }
    

    @IBAction func setSleepMinutes(sender: AnyObject) {
        if let inp = sender as? UITextField {
            let minutes = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            if minutes >= 60 || minutes < 0 {
                errorMessage.text = "Sleep minutes input is not between 0 and 59"
            } else {
                brain!.setTimes(minutes!, field: "sleepMinute")
                errorMessage.text = ""
            }
        }
    }
    

    @IBAction func setWakeHour(sender: AnyObject) {
        if let inp = sender as? UITextField {
            let hour = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            if hour > 12 || hour < 1 {
                errorMessage.text = "Wake hour input is not between 1 and 12"
            } else {
                brain!.setTimes(hour!, field: "wakeHour")
                errorMessage.text = ""
            }
        }
    }
    


    @IBAction func setWakeMinutes(sender: AnyObject) {
        //TODO: FIX ISSUE WHERE IT THINKS ZERO IS NIL!
        if let inp = sender as? UITextField {
            let minutes = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            if minutes >= 60 || minutes < 0 {
                errorMessage.text = "Wake minutes input is not between 0 and 59"
            } else {
                brain!.setTimes(minutes!, field: "wakeMinute")
                errorMessage.text = ""
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! ViewController
        vc.brain = self.brain!
    }
    
    @IBAction func setAlarm(sender: AnyObject) {
        // check if user set times for all fields
        brain!.setAMPM(sleepToggle.currentTitle!, wake: wakeToggle.currentTitle!)
        
        if sleepHourField.text == "" || sleepMinutesField.text == "" || wakeHourField.text == "" || wakeMinutesField.text == "" {
            errorMessage.text = "One or more of the text fields is empty"
        } else {
            // ALSO NEED TO SET CLASS VARS FOR AM PM AND SET IT IN DEFAULTS!
            print("set to sleep at \(brain!.sleepHour!):\(brain!.sleepMinute!) and wake at \(brain!.wakeHour!):\(brain!.wakeMinute!)")
            print("userCheckedRememberSettings = \(userCheckedRememberSettings)")
            if userCheckedRememberSettings == true {
                brain!.setUserDefaults() // this is before you change it to military time!
            } else {
                brain!.clearUserDefaults()
            }
            brain!.setAlarm() // change defaults
            performSegueWithIdentifier("returnToMainView", sender: self)
        }
    }
    
    
}



