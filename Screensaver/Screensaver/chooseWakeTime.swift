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

    @IBOutlet weak var sleepMinutesField: UIButton!
    @IBOutlet weak var sleepHourField: UIButton!
    @IBOutlet weak var wakeHourField: UIButton!
    @IBOutlet weak var wakeMinutesField: UIButton!
    
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var sleepToggle: UIButton!
    @IBOutlet weak var wakeToggle: UIButton!
    @IBOutlet weak var sleepContainer: UIView!
    
    var userCheckedRememberSettings = false
    var brain: ScreensaverBrain!
    var embeddedSleepHourPicker: HourPickerViewController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCheckBox()
        sleepToggle.setTitle("PM", forState: .Normal)
        wakeToggle.setTitle("AM", forState: .Normal)
        errorMessage.text = ""
        if brain.getUserDefaults() == true {
            sleepHourField.setTitle(brain.formatHour(brain.sleepHour!), forState: .Normal)
            sleepMinutesField.setTitle(brain.formatMinutes(brain.sleepMinute!), forState: .Normal)
            wakeHourField.setTitle(brain.formatHour(brain.wakeHour!), forState: .Normal)
            wakeMinutesField.setTitle(brain.formatMinutes(brain.wakeMinute!), forState: .Normal)
            sleepToggle.setTitle(brain.sleepToggle, forState: .Normal)
            wakeToggle.setTitle(brain.wakeToggle, forState: .Normal)
            
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
    

    @IBAction func toggleRemember(sender: AnyObject) {
        if let button = sender as? UIButton {
            if userCheckedRememberSettings == false {
                print("changing to checked")
                button.setBackgroundImage(UIImage(named: "black_checked_box_2.png"), forState: .Normal)
                userCheckedRememberSettings = true
            } else {
                userCheckedRememberSettings = false
                print("changing to unchecked")
                button.setBackgroundImage(UIImage(named: "black_unchecked_box_2.png"), forState: .Normal)
            }
        }
    }

    
    @IBAction func setAlarm(sender: AnyObject) {
        // check if user set times for all fields
        brain!.setAMPM(sleepToggle.currentTitle!, wake: wakeToggle.currentTitle!)
        if sleepHourField.titleLabel == "" || sleepMinutesField.titleLabel == "" || wakeHourField.titleLabel == "" || wakeMinutesField.titleLabel == "" {
            errorMessage.text = "One or more of the fields is empty"
        } else {
            let sleepHour = NSNumberFormatter().numberFromString((sleepHourField.titleLabel?.text)!)?.integerValue
            let sleepMinute = NSNumberFormatter().numberFromString((sleepMinutesField.titleLabel?.text)!)?.integerValue
            let wakeHour = NSNumberFormatter().numberFromString((wakeHourField.titleLabel?.text)!)?.integerValue
            let wakeMinute = NSNumberFormatter().numberFromString((wakeMinutesField.titleLabel?.text)!)?.integerValue
            brain!.setAlarm(sleepHour!, sleepMinute: sleepMinute!, wakeHour: wakeHour!, wakeMinute: wakeMinute!)
            print("set to sleep at \(brain.sleepHour!):\(brain.sleepMinute!) and wake at \(brain.wakeHour!):\(brain.wakeMinute!)")
            print("userCheckedRememberSettings = \(userCheckedRememberSettings)")
            if userCheckedRememberSettings == true {
                brain.setUserDefaults() // this is before you change it to military time!
            } else {
                brain.clearUserDefaults()
            }
            print("about to unwind")
            performSegueWithIdentifier("unwindToMain", sender: self)
        }
    }

    
    // Focus and selection toggles
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == checkBox {
            setCheckBoxWhenSelected()
        } else if context.previouslyFocusedView == checkBox {
            setCheckBox()
        }
    }
    
    func setCheckBoxWhenSelected() {
        if userCheckedRememberSettings == false {
            checkBox.setBackgroundImage(UIImage(named: "black_unchecked_box_2.png"), forState: .Normal)
        } else {
            checkBox.setBackgroundImage(UIImage(named: "black_checked_box_2.png"), forState: .Normal)
        }
    }
    
    func setCheckBox() {
        if userCheckedRememberSettings == false {
            checkBox.setBackgroundImage(UIImage(named: "unchecked_box_2.png"), forState: .Normal)
        } else {
            checkBox.setBackgroundImage(UIImage(named: "checked_box_2.png"), forState: .Normal)
        }
    }
    
    // Overrides
    
    @IBAction func unwindToAlarm(unwindSegue: UIStoryboardSegue) {
        if let _ = unwindSegue.sourceViewController as? TimePicker {
            print("unwound from TimePicker")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ViewController {
            vc.brain = self.brain
        } else if let vc = segue.destinationViewController as? TimePicker {
            vc.brain = self.brain
            if segue.identifier == "sleepHourSegue" {
                sleepPropagation(vc)
                vc.didComeFromHour = true
            } else if segue.identifier == "sleepMinuteSegue" {
                sleepPropagation(vc)
                vc.didComeFromHour = false
            } else if segue.identifier == "wakeHourSegue" {
                wakePropagation(vc)
                vc.didComeFromHour = true
            } else if segue.identifier == "wakeMinuteSegue" {
                wakePropagation(vc)
                vc.didComeFromHour = false
            }
        }
    }
    
    // Helper functions for prepareForSegue
    
    func sleepPropagation(vc: TimePicker!) {
        vc.hourReference = sleepHourField
        vc.minuteReference = sleepMinutesField
        var sh = ""
        var sm = ""
        if let hour = sleepHourField.titleLabel!.text {
            sh = hour
        }
        if let minutes = sleepMinutesField.titleLabel!.text {
            sm = minutes
        }
        propagateLabels(vc, hour: sh, minute: sm)
    }
    
    func wakePropagation(vc: TimePicker) {
        vc.hourReference = wakeHourField
        vc.minuteReference = wakeMinutesField
        var wh = ""
        var wm = ""
        if let hour = wakeHourField.titleLabel!.text {
            wh = hour
        }
        if let minutes = wakeMinutesField.titleLabel!.text {
            wm = minutes
        }
        propagateLabels(vc, hour: wh, minute: wm)
    }

    func propagateLabels(vc: TimePicker, hour: String, minute: String) {
        vc.parentHour = hour
        vc.parentMinute = minute
    }
    
    //    func createButton() {
    //        print("createbutton called")
    //        let sampleTextField = UITextField(frame: CGRectMake(600, 500, 138, 78))
    //        sampleTextField.placeholder = "Enter text here"
    //        sampleTextField.font = UIFont.systemFontOfSize(15)
    //        sampleTextField.borderStyle = UITextBorderStyle.RoundedRect
    //        sampleTextField.autocorrectionType = UITextAutocorrectionType.No
    //        sampleTextField.keyboardType = UIKeyboardType.NumberPad
    //        sampleTextField.returnKeyType = UIReturnKeyType.Done
    //        sampleTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
    //        sampleTextField.backgroundColor = UIColor.blackColor()
    //        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
    //        sampleTextField.delegate = self
    //        self.view.addSubview(sampleTextField)
    //    }
}



