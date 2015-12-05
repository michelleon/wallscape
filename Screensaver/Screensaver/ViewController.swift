//
//  ViewController.swift
//  Screensaver
//
//  Created by Michelle Leon on 11/26/15.
//  Copyright © 2015 Michelle Leon. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //TODO
    // Change focus animation
    // allow user to use remembered settings
    // autopopulate text in text fields
    // implement alarm and sleep functionality
    // set textfield color to white
    // allow list view picker for AM/PM or do custom icon
    // fade to black at sleep with text good night for 30 seconds
    // fade to light at wake with text good morning for 30 seconds

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tempDisplay: UILabel!
    @IBOutlet weak var cityDisplay: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var picLocation: UILabel!
    @IBOutlet weak var locationPin: UIImageView!
    
    var timer = NSTimer()
    var brain = ScreensaverBrain()
    let locationManager = CLLocationManager()
    let weatherKey = "30b27f2565d58ab08511efd9652d8500"
    var mostRecentLat: Double? = nil
    var mostRecentLong: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayTime()
        changeImage()
//        button.backgroundColor = UIColor.clearColor()
        
        //Initializing location services
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
        
        // Getting weather data
//        displayWeather(37.8717, lon: -122.2728) //TODO: remember to convert to double
        
        // recurring timer calls
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("displayTime"),
            userInfo: nil,
            repeats: true)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(120.0, target: self, selector: Selector("changeImage"), userInfo: nil, repeats: true)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3600.0, target: self, selector: Selector("displayWeather"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeImage() {
        if brain.isSleepTime == false {
            let imgNum = Int(arc4random_uniform(6))
            print("chose \(imgNum)")
            background.image = UIImage(named: "wallpaper\(imgNum).jpg");
            if let location = brain.getLocation(imgNum) {
                picLocation.text = location
                locationPin.hidden = false
            } else {
                picLocation.text = ""
                locationPin.hidden = true
            }
        } else {
            picLocation.text = ""
            locationPin.hidden = true
            background.image = UIImage(named: "black.jpg")
        }
    }
    
    func displayTime() {
        let curr_date = NSDate()
        //        let formatter = NSDateFormatter()
        //        formatter.timeStyle = .ShortStyle
        //        time.text! = formatter.stringFromDate(date)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: curr_date)
        var hour = components.hour
        let minutes = components.minute
        let month = monthByNum[components.month]
        let day = components.day
        let year = components.year
        
        if brain.sleepHour == hour && brain.sleepMinute == minutes && brain.userSetAlarm == true {
            goToSleep()
        } else if brain.wakeHour == hour && brain.wakeMinute == minutes {
            wakeUp()
        } else if brain.isSleepTime == true {
            goToSleep()
        } else {
            if hour > 12 {
                hour = hour - 12
            }
            if hour == 0 {
                hour = 12
            }
            if minutes < 10 {
                time.text! = "\(hour):0\(minutes)"
            } else {
                time.text! = "\(hour):\(minutes)"
            }
            date.text! = "\(month!) \(day), \(year)"
        }
        
    }
    
    func goToSleep() {
        // all UI elements go black
        print("goToSleep called")
        brain.isSleepTime = true
        time.text! = ""
        date.text! = ""
        tempDisplay.text = ""
        cityDisplay.text = ""
        weatherIcon.hidden = true
        locationPin.hidden = true
        picLocation.text = ""
        changeImage()
        
    }
    
    func wakeUp() {
        print("wakeUp called")
        brain.isSleepTime = false
        displayTime()
        changeImage()
        displayWeather(mostRecentLat!, lon: mostRecentLong!)
        
    }
    
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
    
    private var iconByNum: [String:String] = [
        "01d" : "sun.png",
        "01n" : "moon.png",
        "02d" : "partly_cloudy.png",
        "02n" : "cloudy_night.png",
        "03d" : "clouds.png",
        "03n" : "clouds.png",
        "04d" : "clouds.png",
        "04n" : "clouds.png",
        "09d" : "rain.png",
        "09n" : "rain.png",
        "10d" : "rain.png",
        "10n" : "rain.png",
        "11d" : "lightning.png",
        "11n" : "lightning.png",
        "13d" : "rain_and_snow.png",
        "13n" : "rain_and_snow.png",
        "50d" : "clouds.png",
        "50n" : "clouds.png"
    ]

    private func getLabels(weatherData: NSData) {
        //        var jsonError: NSError?
        if brain.isSleepTime == false {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: .AllowFragments)
                if let weather = json["weather"] as? [[String: AnyObject]] {
                    if let icon = weather[0]["icon"] as? String {
                        let icon_filename = iconByNum[icon]
                        weatherIcon.image = UIImage(named: icon_filename!);
                        print(icon_filename!) //Remove
                    }
                }
                if let partial = json["main"] as? [String: AnyObject]
                {
                    if let temp = partial["temp"] as? Double
                    {
                        tempDisplay.text = String(format:"%.0f℉", temp) //TODO: Option to switch b/t celcius and fare
                    }
                }
                if let city = json["name"] as? String {
                    cityDisplay.text = city
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
    }
    
    func displayWeather(lat:Double, lon:Double) {
        mostRecentLat = lat
        mostRecentLong = lon
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(weatherKey)"
        let url = NSURL(string: urlString)
        print("\(url)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), { self.getLabels(data!) })
            } else {
                print("error with NSURLSession")
            }
        }
        task.resume()
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("loc delegate called")
        var lat = 37.8717
        var lon = -122.2728
        
//        if let loc = manager.location {
        if let loc = locations.last {
            let locValue:CLLocationCoordinate2D = loc.coordinate
                print("locations = \(locValue.latitude) \(locValue.longitude)")
                lat = Double(locValue.latitude)
                lon = Double(locValue.longitude)
            displayWeather(lat, lon: lon)
        } else {
            print("error with manager.location in delegate")
        }
//        displayWeather(lat, lon: lon)

    }
//
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        
//        let locationZoom = locations.last as! CLLocation
//        let latitude: Double = locationZoom.coordinate.latitude
//        let longitude: Double = locationZoom.coordinate.longitude
//        print(latitude)
//        print(longitude)
//    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! chooseWakeTime
        vc.brain = self.brain
    }
    
    
}

class chooseWakeTime: UIViewController {
    

    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var sleepHourField: UITextField!
    @IBOutlet weak var sleepMinutesField: UITextField!
    @IBOutlet weak var wakeHourField: UITextField!
    @IBOutlet weak var wakeMinutesField: UITextField!
    
    var userCheckedRememberSettings = false
    var brain: ScreensaverBrain? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBox.setBackgroundImage(UIImage(named: "unchecked_box_2.png"), forState: .Normal)
        checkBox.setImage(UIImage(named: "checked_box_2.png"), forState: .Selected)
        checkBox.backgroundColor = UIColor.clearColor()
//        print("\(brain!.userSetAlarm)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toggleRemember(sender: AnyObject) {
        print("selected checkbox")
        if userCheckedRememberSettings == false {
            sender.setBackgroundImage(UIImage(named: "checked_box_2.png"), forState: .Normal)
            userCheckedRememberSettings = true
        } else {
            userCheckedRememberSettings = false
            sender.setBackgroundImage(UIImage(named: "unchecked_box_2.png"), forState: .Normal)
        }
    }
    
    @IBAction func setSleepHour(sender: AnyObject) {
        if let inp = sender as? UITextField {
            let hour = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            brain!.setSleepHour(hour!)
        } else {
            // handle invalid input, give feedback maybe
        }
    }
    
    @IBAction func setSleepMinutes(sender: AnyObject) {
        if let inp = sender as? UITextField {
            let minutes = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            brain!.setSleepMinutes(minutes!)
        } else {
            // handle invalid input
        }
    }
    
    @IBAction func setWakeHour(sender: AnyObject) {
        if let inp = sender as? UITextField {
            let hour = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            brain!.setWakeHour(hour!)

        } else {
            // handle invalid input, give feedback maybe
        }
    }
    
    @IBAction func setWakeMinutes(sender: AnyObject) {
        if let inp = sender as? UITextField {
            let minutes = NSNumberFormatter().numberFromString(inp.text!)?.integerValue
            brain!.setWakeMinutes(minutes!)
        } else {
            // handle invalid input
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let model = brain {
//            print("set to sleep at \(model.sleepHour):\(model)!.sleepMinute) and wake at \(model.wakeHour!):\(model.wakeMinute!)")
//            brain!.userSetAlarm = true
//        }
////        let vc = segue.destinationViewController as! chooseWakeTime
////        vc.brain = self.brain
//    }
    
    @IBAction func setAlarm(sender: AnyObject) {
        print("set to sleep at \(brain!.sleepHour!):\(brain!.sleepMinute!) and wake at \(brain!.wakeHour!):\(brain!.wakeMinute!)")
        brain!.userSetAlarm = true //TODO: Make sure to set this back to false and reset all variables after goodmorning
    }
}


