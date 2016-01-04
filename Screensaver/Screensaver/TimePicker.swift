//
//  TimePicker.swift
//  Screensaver
//
//  Created by Michelle Leon on 12/27/15.
//  Copyright © 2015 Michelle Leon. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class TimePicker: UIViewController {

    var brain: ScreensaverBrain? = nil
    private var hourVC: HourPickerViewController!
    private var minuteVC: MinutePickerViewController!
    var hourReference: UIButton!
    var minuteReference: UIButton!
    var parentHour: String!
    var parentMinute: String!
//    var defaultFocus: UIContainer
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var minutes: UILabel!
    
    override func viewDidLoad() {
        setLabels()
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
    
    // propagate the selection fromt he picker up to this
    // display selection in label
    // propagate final selection when you hit the done button to the previous and do the unwind
    func setLabels() {
        self.hour.text = parentHour
        self.minutes.text = parentMinute
    }
    
    @IBAction func finishedEditing(sender: AnyObject) {
        hourReference.setTitle(hour.text, forState: .Normal)
        minuteReference.setTitle(minutes.text, forState: .Normal)
        performSegueWithIdentifier("unwindToAlarm", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? HourPickerViewController {
            if segue.identifier == "hourEmbeddedSegue" {
                self.hourVC = vc
                print("hourEmbeddedSegue occured")
            }
        }
        if let vc = segue.destinationViewController as? MinutePickerViewController {
            if segue.identifier == "minuteEmbeddedSegue" {
                self.minuteVC = vc
                print("minuteEmbeddedSegue occurred")
            }
        }
    }
    
    // if hourPicker is done, then do hourPicker.ndexPathForSelectedRow to find out which hour they picked
    // pass this on to brain
}