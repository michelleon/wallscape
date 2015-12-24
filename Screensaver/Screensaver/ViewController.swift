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
//     Change focus animation
//     Get rid of next on keyboard for uitext fields
//     fade to black at sleep with text good night for 30 seconds
//     fade to light at wake with text good morning for 30 seconds
//     set text field color to white
//     make funny greetings
//     make black a separate view controller
//     Fix weather bug, if it doesn't work then just don't show weather or show most recent?
// make the picture black on the remember settings checkbox


    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tempDisplay: UILabel!
    @IBOutlet weak var cityDisplay: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var picLocation: UILabel!
    @IBOutlet weak var locationPin: UIImageView!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var alarmClockButton: UIButton!

    var timer = NSTimer()
    var brain = ScreensaverBrain()
    let locationManager = CLLocationManager()
    let weatherKey = "30b27f2565d58ab08511efd9652d8500"
    var mostRecentLat: Double? = nil
    var mostRecentLong: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI Elements
        greeting.text = ""
        
        // Do any additional setup after loading the view, typically from a nib.
        updateTime()
        changeImage()
//        button.backgroundColor = UIColor.clearColor()
        
        //Initializing location services
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
        
        // recurring timer calls
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("updateTime"),
            userInfo: nil,
            repeats: true)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(120.0, target: self, selector: Selector("changeImage"), userInfo: nil, repeats: true)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3600.0, target: self, selector: Selector("displayWeather"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
//
//        //super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
//        //context.nextFocusedView.b
//        print("Button Focused");
//    }
    
    func changeImage() {
        if brain.isSleepTime == false {
            let imgNum = Int(arc4random_uniform(16))
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
            print("in the isSleepTime part of changeImage")
            picLocation.text = ""
            locationPin.hidden = true
            background.image = UIImage(named: "black.jpg")
        }
    }
    
    func updateTime() {
        let curr_date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: curr_date)
        let hour = components.hour
        let minutes = components.minute
        let month = monthByNum[components.month]
        let day = components.day
        let year = components.year

        if brain.isSleepTime == true {
            if (brain.wakeHour != nil) && (brain.wakeMinute != nil) {
                print("brain wake time \(brain.wakeHour!):\(brain.wakeMinute)")
                if brain.wakeHour! == hour && (brain.wakeMinute! == minutes) {
                    print("wakeUp called")
                    wakeUp()
                }
            }
        } else if let sleepHour = brain.sleepHour {
            if let sleepMinute = brain.sleepMinute {
                if (sleepHour == hour) && (sleepMinute == minutes) && (brain.userSetAlarm == true) {
                    print("goToSleep called first time")
                    goToSleep()
                } else {
                    displayTime(hour, minutes: minutes, month: month, day: day, year: year)
                }
            }
        } else {
            displayTime(hour, minutes: minutes, month: month, day: day, year: year)
        }
    }
    
    func displayTime(hour: Int, minutes: Int, month: String?, day: Int, year: Int ) {
        var displayHour = hour
        if hour > 12 {
            displayHour = hour - 12
        }
        if hour == 0 {
            displayHour = 12
        }
        let displayMinutes = brain.formatMinutes(minutes)
        time.text! = "\(displayHour):\(displayMinutes)"
        date.text! = "\(month!) \(day), \(year)"
    }
    
    
    
    func goToSleep() {
        // all UI elements go black
//        print("goToSleep called")
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
//        print("wakeUp called")
        greeting.text = brain.getGreetingByTimeOfDay(brain.wakeHour!)
        brain.resetAlarm()
        updateTime()
        changeImage()
        displayWeather(mostRecentLat!, lon: mostRecentLong!)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(120.0, target: self, selector: Selector("removeGreeting"), userInfo: nil, repeats: false)
    }
    
    func removeGreeting() {
        greeting.text = ""
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

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! chooseWakeTime
        vc.brain = self.brain
    }
    
    
}



